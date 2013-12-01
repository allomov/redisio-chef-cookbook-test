
include_recipe 'recipe[redisio]',           # prepare environment
include_recipe 'recipe[redisio::install]',  # install redis
include_recipe 'recipe[redisio::enable]'    # run redis services
