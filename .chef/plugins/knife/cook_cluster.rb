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

        puts "@json_config: " + @json_config.inspect
        puts "curre dir: " + File.expand_path('.', )
        
        validate_config!(@json_config)

        master   = @json_config['master']
        slaves   = @json_config['slaves']
        sentinel = @json_config['sentinel']
        kepypair = @json_config['keypair']


        Chef::Log.info("Deploying Redis master at #{master['address']}.")
        puts "knife solo bootstrap -i #{kepypair} root@#{master['address']} nodes/redis-master.json"
        exec "knife solo bootstrap -i #{kepypair} root@#{master['address']} nodes/redis-master.json"

        slaves.each do |slave_address|
          Chef::Log.info("Deploying Redis slave at #{slave_address}.")
          exec "knife solo bootstrap -i #{kepypair} root@#{slave_address} nodes/redis-slave.json"
        end

        Chef::Log.info("Deploying Redis sentinel at #{sentinel}.")
        exec "knife solo bootstrap -i #{kepypair} root@#{sentinel} nodes/redis-sentinel.json" 
      end

      def validate_config!(config)
        validate_keys! %w(master slaves sentinel), config
        validate_keys! %w(address port), config['master']
      end

      def validate_keys!(required_keys, config)
        keys_checks = required_keys.map { |key| config.key?(key) }
        raise "Your config doesn't have required fields." if !keys_checks.all?        
      end
    end



  end
end
