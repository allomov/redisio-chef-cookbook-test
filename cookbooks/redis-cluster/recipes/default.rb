#
# Cookbook Name:: redis-cluster
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'recipe[redis-cluster::enable_ports]'
include_recipe 'recipe[redis-cluster::install_redis]'
