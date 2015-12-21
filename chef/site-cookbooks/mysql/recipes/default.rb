#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, CINRA, inc.
#
# All rights reserved - Do Not Redistribute
#

%w[
  mysql
  mysql-server
  mysql-devel
].each do |pkg|
  package pkg do
    action :install
  end
end

template '/etc/my.cnf' do
  source "my.cnf.erb"
  owner 'root'
  group 'root'
  mode 644
  notifies :restart, "service[mysqld]"
end

service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable , :start ]
end

user = node['mysql']['user']
password = node['mysql']['password']
ip = node['mysql']['ip']
dbname = node['mysql']['dbname']
root_password = node['mysql']['root_password']

bash "mysql_remove_testdb" do
  code <<-EOC
    mysql -u root -e "DROP DATABASE IF EXISTS test;"
    mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
  EOC
  only_if "mysql -u root -e 'show databases'"
end

bash "mysql_remove_auth_from_root" do
  code <<-EOC
    mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
    mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('#{root_password}');" -D mysql
  EOC
  only_if "mysql -u root -e 'show databases'"
end

bash "mysql_set_passwords" do
  code <<-EOC
    mysql -u root -p#{root_password} -e "SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('#{root_password}');" -D mysql
    mysql -u root -p#{root_password} -e "SET PASSWORD FOR 'root'@'::1' = PASSWORD('#{root_password}');" -D mysql
    mysql -u root -p#{root_password} -e "GRANT ALL PRIVILEGES ON *.* TO '#{user}'@'localhost';" -D mysql
    mysql -u root -p#{root_password} -e "GRANT ALL PRIVILEGES ON *.* TO '#{user}'@'127.0.0.1';" -D mysql
    mysql -u root -p#{root_password} -e "GRANT ALL PRIVILEGES ON *.* TO '#{user}'@'::1';" -D mysql
    mysql -u root -p#{root_password} -e "SET PASSWORD FOR '#{user}'@'localhost' = PASSWORD('#{password}');" -D mysql
    mysql -u root -p#{root_password} -e "SET PASSWORD FOR '#{user}'@'127.0.0.1' = PASSWORD('#{password}');" -D mysql
    mysql -u root -p#{root_password} -e "SET PASSWORD FOR '#{user}'@'::1' = PASSWORD('#{password}');" -D mysql
    mysql -u root -p#{root_password} -e "FLUSH PRIVILEGES;"
  EOC
end

bash "mysql_createdb" do
  code <<-EOC
    mysql -u #{user} -p#{password} -e "CREATE DATABASE IF NOT EXISTS #{dbname};"
  EOC
  only_if "mysql -u #{user} -p#{password} -e 'show databases'"
end