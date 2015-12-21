#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# php

remi_name = 'remi-release-6'
bash "remi_update" do
  code <<-EOC
    rpm -Uvh http://rpms.famillecollet.com/enterprise/#{remi_name}.rpm
  EOC
  not_if "rpm -qa|grep #{remi_name}"
end

package "php" do
  action :install
  options "--enablerepo=remi-php55"
  notifies :restart, 'service[httpd]'
end

%w[
  gd-last
  ImageMagick-last
].each do |pkg|
  package "#{pkg}" do
    action :install
    options "--enablerepo=remi"
    notifies :restart, "service[httpd]"
  end
end

%w[
  php-pdo
  php-mbstring
  php-mysqlnd
  php-gd
  php-pear
  php-imagick
  php-ssh2
].each do |pkg|
  package "#{pkg}" do
    action :install
    options "--enablerepo=remi-php55"
    notifies :restart, "service[httpd]"
  end
end

template "/etc/php.ini" do
	source "php.ini.erb"
	owner "root"
	group "root"
	mode 0644
	notifies :restart, "service[httpd]"
end

%w[
  date
].each do |pkg|
	template "/etc/php.d/#{pkg}.ini" do
		source "#{pkg}.ini.erb"
		owner "root"
		group "root"
		mode 0644
		notifies :restart, "service[httpd]"
	end
end