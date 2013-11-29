#
# Cookbook Name:: redisio-cluster
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


include_recipe 'recipe[redisio]', 'recipe[redisio::install]', 'recipe[redisio::enable]'    # run redis services

