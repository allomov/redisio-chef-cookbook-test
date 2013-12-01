require 'chef/knife'

module Plugins
  module Knife

    class CookCluster < Chef::Knife

      deps do
        # require 'chef/dependency'
        # require 'chef/data_bag'
        Chef::Config[:solo] = true
        require 'json'
        require 'chef/data_bag'
        require 'knife-solo_data_bag'
      end

      option :json,    
        :short => "-j VALUE",
        :long => "--json VALUE",
        :description => "json cluster config",
        :boolean => false,
        :default => 'cluster.json'

      def run

        # load config
        @json_config_file = name_args.first || config[:json]
        @json_config = JSON.parse(File.read(@json_config_file))

        validate_config!(@json_config)

        @master   = @json_config['master']
        @slaves   = @json_config['slaves']
        @sentinel = @json_config['sentinel']
        @kepypair = @json_config['keypair']
        @chef_server = @json_config['chef-server']
        @user = 'root'

        # save data bag
        redis_master_config = Chef::DataBagItem.load('redis', 'master')
        redis_master_config['address'] = @master['address']
        redis_master_config.save

        # deploy cluster
        knife_solo_bootstrap(@master['address'], 'nodes/redis-master.json')
        @slaves.each do |slave_address|
          knife_solo_bootstrap(slave_address, 'nodes/redis-slave.json')
        end
        knife_solo_bootstrap(@sentinel, 'nodes/redis-sentinel.json')

        knife_solo_bootstrap(@chef_server, 'nodes/chef-server.json') if @chef_server

      end

      def validate_config!(config)
        validate_keys! %w(master slaves sentinel), config
        validate_keys! %w(address port), config['master']
      end

      def validate_keys!(required_keys, config)
        keys_checks = required_keys.map { |key| config.key?(key) }
        unless keys_checks.all?
          raise "Your config doesn't have required fields.\n" +
                "expected keys #{required_keys.inspect}\n" +
                "got #{config.keys.inspect}\n" +
                "in #{config.inspect}"
        end
      end

      def safe_exec(command)
        is_success = system(command)
        raise "#{command} exited with exception." unless is_success
      end

      def knife_solo_bootstrap(address, node_config)
        Chef::Log.info("Deploying Redis at #{address} with #{node_config} config.")
        safe_exec("knife solo bootstrap -i #{@kepypair} #{@user}@#{address} #{node_config}" )
      end

    end


  end
end
