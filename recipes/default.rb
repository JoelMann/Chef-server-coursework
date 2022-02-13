#
# Cookbook:: myhaproxy
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.
apt_update

haproxy_install 'package'

haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'servers'
end

haproxy_backend 'servers' do
  server ['web1 192.168.10.43:80 maxconn 32']
#   notifies :reload, "haproxy_service[haproxy]", :immediately 
# doing this for a future test  - github issue -> check on a future version. 
end

haproxy_service 'haproxy' do
  action %i(create enable start)
  subscribes :reload 'template[/etc/haproxy/haproxy.cfg]', :immediately
end