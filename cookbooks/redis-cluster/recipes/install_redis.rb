
include_recipe 'redisio'           # prepare environment
include_recipe 'redisio::install'  # install redis
include_recipe 'redisio::enable'   # run redis services
