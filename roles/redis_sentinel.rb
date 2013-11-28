name 'redis-sentinel'
description 'Redis Sentinel Node'

run_list 'recipe[redisio]', 'recipe[redisio::enable]'

redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    'sentinels' => [
      {
        'sentinel_port' => 26379, 
        'name' => 'sentinels', 
        'master_ip' => '192.168.50.5', 
        'master_port' => '6379'
      }
    ]    
  }
})
