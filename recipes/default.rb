#
# Cookbook:: node_cookbook
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'apt'

apt_update 'update_sources' do
  action :update
end

apt_repository 'mongodb-org' do
  uri 'https://repo.mongodb.org/apt/ubuntu'
  distribution 'xenial/mongodb-org/3.2'
  components ['multiverse']
  #key 'https://www.mongodb.org/static/pgp/server-4.2.asc'
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key 'EA312927'
  # action :add
  #deb_src true
end

package 'mongodb-org' do
  options '--allow-unauthenticated'
  action :upgrade
end

# /etc/mongod.conf

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables port: node['mongodb']['port'], bindIp: node['mongodb']['bindIp']
  notifies :restart, 'service[mongod]'
end

template '/lib/systemd/system/mongod.service' do
  source 'mongod.service.erb'
  mode '777'
  owner 'root'
  group 'root'
  notifies :restart, 'service[mongod]'
end

service 'mongod' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
#
# include_recipe 'apt'
# #
# file '/etc/mongod.conf' do
# end
#
# file '/lib/systemd/system/mongod.service' do
# end
