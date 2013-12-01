name 'redis-master'
description 'Redis Master Node'

run_list  'simple_iptables',
          'recipe[redisio]',           # prepare environment
          'recipe[redisio::install]',  # install redis
          'recipe[redisio::enable]'    # run redis services

# Allow SSH
simple_iptables_rule "ssh" do
  rule "--proto tcp --dport 22"
  jump "ACCEPT"
end

redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    'servers' => [
      {
        'name' => 'master',
        'backuptype' => 'both',
        'port' => redis_master_config['port']
      }
    ]
  }
})

