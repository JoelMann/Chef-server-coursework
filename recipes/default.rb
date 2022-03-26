#
# Cookbook:: myhaproxy
# Recipe:: default
# NEW
# Copyright:: 2022, The Authors, All Rights Reserved.
apt_update

haproxy_install 'package'

haproxy_frontend 'http-in' do
  bind '*:80'
  default_backend 'servers'
end

all_web_nodes = search(:node, "role:web AND chef_environment:#{node.chef_environment}")

servers = []

all_web_nodes.each do |web_node|
  server = "#{web_node['hostname']} #{web_node['ipaddress']}:80 maxconn 32"
  servers.push(server)
end

haproxy_backend 'servers' do
  server servers
#   notifies :reload, "haproxy_service[haproxy]", :immediately 
# doing this for a future test  - github issue -> check on a future version. 
end

haproxy_service 'haproxy' do
  action %i(create enable start)
  subscribes :reload, "template[/etc/haproxy/haproxy.cfg]", :immediately
end