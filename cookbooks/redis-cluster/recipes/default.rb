
# include_recipe 'redis-cluster::enable_ports'
include_recipe 'build-essential'
include_recipe 'redis-cluster::install_redis'
