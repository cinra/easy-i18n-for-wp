#
# Cookbook Name:: adduser
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# group
group node['user']['group'] do
  action :create
end

# adduser
user node['user']['name'] do
  home node['user']['home']
  password node['user']['password']
  gid node['user']['group']
  action :create
end

# ssh
# directory '/var/www/.ssh' do
# 	action :create
# 	user 'cinra'
# 	mode 0700
# end

# file '/var/www/.ssh/authorized_keys' do
# 	action :create
# 	mode 0600
# end

# package 'libxml2-devel' do
# 	action :install
# end