#
# Cookbook Name:: dzix
# Recipe:: default
#
# Copyright 2013, Stas A. Kraev
#
# All rights reserved - Do Not Redistribute
#
chef_gem 'zabbixapi' do
  action :install
  version node['dzix']['zabbixapiversion']
end
