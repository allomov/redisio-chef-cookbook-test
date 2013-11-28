name 'redis-master'
description 'Redis Master Node'

run_list 'recipe[redisio]', 'recipe[redisio::install]', 'recipe[redisio::enable]'

redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    'servers' => [
      {
        'job_control' => 'initd',
        'name' => 'master',
        'backuptype' => 'both',
        'port' => redis_master_config['port']
      }
    ]
  }
})

