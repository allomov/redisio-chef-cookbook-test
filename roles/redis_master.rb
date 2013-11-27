name 'redis-master'
description 'Redis Master Node'

server_name = 'master'

run_list 'recipe[redisio-cluster]', 'recipe[redisio]', 'recipe[redisio::enable]'


redis_master_config = Chef::DataBagItem.load('redis', 'master')

default_attributes({
  'redisio' => {
    # 'default_settings' => {'datadir' => '/mnt/redis'},
    'servers' => [
      {
        'name' => server_name,
        'backuptype' => 'both',
        'port' => redis_master_config['port']
      }
    ]
  }
})

Chef::Log.info("Compiling Redis Master setup")
