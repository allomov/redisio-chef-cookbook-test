name 'redis-slave'
description 'Redis Slave Node'

run_list 'recipe[redisio]',           # prepare environment
         'recipe[redisio::install]',  # install redis
         'recipe[redisio::enable]'    # run redis

redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    'servers' => [
      {
        'name' => 'slave',
        'port' => 6379, 
        'slaveof' => { 
          'address' => redis_master_config['address'],
          'port'    => redis_master_config['port']
        }
      }
    ]
  }
})

Chef::Log.info("Compiling Redis Slave setup")
