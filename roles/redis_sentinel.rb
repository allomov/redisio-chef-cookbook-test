name 'redis-sentinel'
description 'Redis Sentinel Node'

run_list  'recipe[simple_iptables]',
          'recipe[redis-cluster::enable_ports]',
          'recipe[redisio]',
          'recipe[redisio::install]',
          'recipe[redisio::configure]',
          'recipe[redisio::sentinel]',          # prepare environment, install redis sentinel
          'recipe[redisio::sentinel_enable]'    # run redis sentinel

redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    'sentinels' => [
      {
        'sentinel_port' => 26379, 
        'name'          => 'master', 
        'master_ip'     => redis_master_config['address'], 
        'master_port'   => redis_master_config['port']
      }
    ]    
  }
})
