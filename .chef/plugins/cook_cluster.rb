require 'chef/knife'
# other require attributes, as needed

# knife cluster cook redis development

module Cookies
  class Cluster < Chef::Knife

  deps do
    require 'chef/dependency'
    # other dependencies, as needed
  end

  banner "helps to deploy cluster setup in one command"

  option :name_of_option,
    :short => "-l VALUE",
    :long => "--long-option-name VALUE",
    :description => "The description for the option.",
    :proc => Proc.new { code_to_run }
    :boolean => true | false
    :default => default_value

  def run
    # Ruby code goes here
    puts 'hello'
  end
end