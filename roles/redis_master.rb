name 'redis-master'
description 'Redis Master Node'

run_list 'recipe[redisio]',           # prepare environment
         'recipe[redisio::install]',  # install redis
         'recipe[redisio::enable]'    # run redis services

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

