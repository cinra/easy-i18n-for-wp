#
# Cookbook Name:: httpd
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# apache

%w[
  httpd
  httpd-devel
  mod_ssl
].each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

template '/etc/httpd/conf/httpd.conf' do
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  # notifies :restart, "service[httpd]"
end

template '/etc/httpd/conf.d/vhosts.conf' do
	source "vhosts.conf.erb"
  owner "root"
  group "root"
  mode 0644
  # notifies :restart, "service[httpd]"
end

service "httpd" do
  supports :status => true, :reload => true, :restart => true
  action [ :enable, :start ]
end