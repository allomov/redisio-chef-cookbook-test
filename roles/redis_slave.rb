name 'redis-slave'
description 'Redis Slave Node'

run_list 'recipe[redisio]', 'recipe[redisio::enable]'

redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    'servers' => [
      {
        'slaveof' => { 
          'address' => redis_master_config['address'],
          'port' => redis_master_config['port']
        }
      }
    ]
  }
})

Chef::Log.info("Compiling Redis Slave setup")
