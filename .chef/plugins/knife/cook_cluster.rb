require 'chef/knife'

module Plugins
  module Knife

    class CookCluster < Chef::Knife

      deps do
        # require 'chef/dependency'
        # require 'chef/data_bag'
        require 'json'
      end

      option :json,    
        :short => "-j VALUE",
        :long => "--json VALUE",
        :description => "json cluster config",
        :boolean => false,
        :default => 'cluster.json'

      def run

        @json_config_file = name_args.first || config[:json]
        @json_config = JSON.parse(File.read(@json_config_file))

        validate_config!(@json_config)

        @master   = @json_config['master']
        @slaves   = @json_config['slaves']
        @sentinel = @json_config['sentinel']
        @kepypair = @json_config['keypair']
        @user = 'root'

        knife_solo_bootstrap(@master['address'], 'nodes/redis-master.json')
        @slaves.each do |slave_address|
          knife_solo_bootstrap(slave_address, 'nodes/redis-slave.json')
        end
        knife_solo_bootstrap(@sentinel, 'nodes/redis-sentinel.json')

      end

      def validate_config!(config)
        validate_keys! %w(master slaves sentinel), config
        validate_keys! %w(address port), config['master']
      end

      def validate_keys!(required_keys, config)
        keys_checks = required_keys.map { |key| config.key?(key) }
        raise "Your config doesn't have required fields." if !keys_checks.all?        
      end

      def safe_exec(command)
        is_success = system(command)
        raise "#{command} exited with #{code} status." unless is_success
      end

      def knife_solo_bootstrap(address, node_config)
        Chef::Log.info("Deploying Redis at #{address} with #{node_config} config.")
        safe_exec("knife solo bootstrap -i #{@kepypair} #{@user}@#{address} #{node_config}" )
      end

    end



  end
end
