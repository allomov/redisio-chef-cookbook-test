name 'redis-master'
description 'Redis Master Node'

run_list  'recipe[redis-cluster]'

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
