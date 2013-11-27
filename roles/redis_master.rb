name 'redis-master'
description 'Redis Master Node'

server_name = 'master'

run_list 'recipe[redisio]', 'recipe[redisio::enable]'


default_attributes({
  'redisio' => {
    'default_settings' => {'datadir' => '/mnt/redis'},
    'servers' => [{'port' => '6379'}, {'port' => '6380', 'name' => "MyInstance"}]
  }
})

# # redis_master_config = Chef::DataBagItem.load('redis', 'master')

# default_attributes({})

# default_attributes({
#   'redisio' => {
#     'servers' => [
#       {
#         'job_control' => 'initd',
#         'name' => server_name,
#         'backuptype' => 'both',
#         'port' => redis_master_config['port']
#       }
#     ]
#   }
# })

Chef::Log.info("Compiling Redis Master setup")
