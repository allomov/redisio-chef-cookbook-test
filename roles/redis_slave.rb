name 'redis-slave'
description 'Redis Slave Node'

# run_list 'recipe[simple_iptables]',
# run_list 'recipe[redis-cluster::enable_ports]', 
run_list 'recipe[redisio]', 
         'recipe[redisio::install]', 
         'recipe[redisio::enable]'

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
