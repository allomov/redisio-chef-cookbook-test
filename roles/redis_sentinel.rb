name 'redis-sentinel'
description 'Redis Sentinel Node'

run_list 'recipe[redisio]',           # prepare environment
         'recipe[redisio::install]',  # install redis
         'recipe[redisio::enable]'    # run redis

redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    'sentinels' => [
      {
        'sentinel_port' => 26379, 
        'name' => 'sentinels', 
        'master_ip' => redis_master_config['address'], 
        'master_port' => redis_master_config['port']
      }
    ]    
  }
})
