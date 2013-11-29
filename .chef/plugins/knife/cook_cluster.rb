require 'chef/knife'

module Plugins
  module Knife

    class CookCluster < Chef::Knife

      deps do
        # require 'chef/dependency'
        # require 'chef/data_bag'
      end

      option :name,    
        :short => "-n VALUE",
        :long => "--name VALUE",
        :description => "Cluster name.",
        :boolean => false,
        :default => 'redis'

      def run

        @name = name_args.first || config[:name]

        puts "cluster name: " + @name
        
        @config = Chef::DataBagItem.load('cluster', @name)

        puts "cluster config: " + @config.inspect

        validate_config!

        @master   = @config['master']
        @slaves   = @config['slaves']
        @sentinel = @config['sentinel']

      end

      def validate_config!
        validate_keys! %w(master slaves sentinel), @config
        validate_keys! %w(address port), @config['master']
      end

      def validate_keys!(required_keys, config)
        keys_checks = required_keys.map { |key| config.key?(key) }
        raise "Your config doesn't have required fields." if !keys_checks.all?        
      end
    end



  end
end
