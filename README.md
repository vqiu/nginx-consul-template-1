# Nginx-Consul-Template
An example template for rendering an nginx configuration file with Consul Template.

## Description
The purpose of this project is creating dynamic configurations with Consul Template which can query a service entries, keys, and key values in Consul.
## Usage
This example assumes Consul and Consul Template are installed.
#### Example
* Register Entity

<pre><code>
 curl -X PUT http://localhost:8500/v1/catalog/register -d'{"Node" : "server1", "Address" : "172.16.4.11", "Service":{"ID" : "172.16.4.11:80", "Service": "v1", "Port":80}, "NodeMeta":{"location" : "v1", "upstream" : "v1_dev_example_com"}}'
curl -X PUT http://localhost:8500/v1/catalog/register -d'{"Node" : "server2", "Address" : "172.16.4.12", "Service":{"ID" : "172.16.4.12:80", "Service": "v1", "Port":80}, "NodeMeta":{"location" : "v1", "upstream" : "v1_dev_example_com"}}'

curl -X PUT http://localhost:8500/v1/catalog/register -d'{"Node" : "server3", "Address" : "172.16.4.21", "Service":{"ID" : "172.16.4.21:80", "Service": "v2", "Port":80}, "NodeMeta":{"location" : "v2", "upstream" : "v2_dev_example_com"}}'
curl -X PUT http://localhost:8500/v1/catalog/register -d'{"Node" : "server4", "Address" : "172.16.4.22", "Service":{"ID" : "172.16.4.22:80", "Service": "v2", "Port":80}, "NodeMeta":{"location" : "v2", "upstream" : "v2_dev_example_com"}}'
</pre></code>
* Run Consul Template
<pre><code>
consul-template -consul-addr 127.0.0.1:8500 \
    -template "consul_server_conf.tpl:/opt/openresty/nginx/conf/consul_server.conf" \
    -template "consul_upstream_conf.tpl:/opt/openresty/nginx/conf/consul_upstream.conf" \
    -exec=" /opt/openresty/nginx/sbin/nginx -c /opt/openresty/nginx/conf/consul.conf -s reload "
</pre></code>
* Output
You should see output similar to the following:
<pre><code>
-- consul_upstream.conf
upstream test {
    server 192.168.46.115:1234 max_fails=3 fail_timeout=10 weight=1;
    server 192.168.46.155:1234 max_fails=3 fail_timeout=10 weight=1;
}

-- consul_server.conf
server {
    listen 1234;
    location /test{
        proxy_pass http://test;
    }
}
</pre></code>
## Copyright and License
The MIT License (MIT) Copyright (c) 2017 xiaoxuanzi xiaoximou@gmail.com
## See Also
* Consul Template: https://github.com/hashicorp/consul-template
* Consul: https://www.consul.io/
