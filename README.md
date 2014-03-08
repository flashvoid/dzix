dzix
====

Zabbix cookbook for AWS

provides LWRPs for hosts autoregistration


Requirements
------------
```chef
	gem zabbixapi
```

Attributes
----------
Configurable attributes
```chef
attribute :zabbix_debug,           True or False, enable debug output from api library
attribute :zabbix_host_ip,         IP address for zabbix host interface :default => "127.0.0.1"
attribute :zabbix_host_dns,        DNS name for zabbix host interface   :default => "localhost"
attribute :groups,                 List/String of group names to put zabbix host in
attribute :templates,              List/String of templates names to link with zabbix host
attribute :zabbix_user,            Zabbix username with api access
attribute :zabbix_url,             Zabbix server url (ex: http://zabbix.example.com/api_jsonrpc.php )
attribute :zabbix_password,        Password for api access
attribute :parameters,             Optional hash of parameters passed directly to api
```

Check zabbix wiki for this options, usually leave it as default
```chef
attribute :zabbix_int_type,        :kind_of => Integer, :default => 1
attribute :zabbix_int_main,        :kind_of => Integer, :default => 1
attribute :zabbix_int_useip,       :kind_of => Integer, :default => 0
attribute :zabbix_int_port,        :kind_of => Integer, :default => 10050
```

#### dzix::default
Include to enable LWRP

LWRP
-----
#### 

```chef
param = { "inventory" => { "tag"  => "mytag" } }

dzix_host node["ec2"]["instance_id"] do
  zabbix_debug true
  zabbix_user "api"
  zabbix_url "http://zabbix.example.com/api_jsonrpc.php"
  zabbix_password "secure"
  zabbix_host_ip node["ec2"]["public_ipv4s"]
  zabbix_host_dns node["ec2"]["public_hostname"]
  templates [ "Template_Linux", "Template_Standalone" ]
  groups "Desktop Computers"
  parameters param
  action [ :register, :linktemplates ]
end

dzix_host node["ec2"]["instance_id"] do
  zabbix_debug true
  zabbix_user "api"
  zabbix_url "http://zabbix.example.com/api_jsonrpc.php"
  zabbix_password "secure"
  action [ :deregister ]
end
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Stas A. Kraev
