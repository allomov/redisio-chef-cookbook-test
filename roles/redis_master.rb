name 'redis-master'
description 'Redis Master Node'

# run_list 'recipe[redis-cluster]'
# run_list 'recipe[simple_iptables]',
# 'recipe[redis-cluster::enable_ports]', 
run_list 'recipe[redisio]', 
         'recipe[redisio::install]', 
         'recipe[redisio::enable]'

redis_master_config = Chef::DataBagItem.load('redis', 'master')

mode = redis_master_config['mode'] 
backuptype_converter = {'cache' => 'rdb', 'transient' => 'rdb', 'acid' => 'both'}
backuptype = backuptype_converter[mode]

save_config = (mode == 'cache') ? [] : (redis_master_config['save'] || ["900 1", "300 10", "60 10000"])

default_attributes({
  'redisio' => {
    'servers' => [
      {
        'name' => 'master',
        'backuptype' => 'both',
        'port' => redis_master_config['port'], 
        'backuptype' => backuptype,
        'save' => save_config
      }
    ]
  }
})
