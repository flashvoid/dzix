actions :register, :update, :create_and_update, :deregister, :linktemplates

attribute :zabbix_debug,           :kind_of => [TrueClass, FalseClass], :default => false
attribute :zabbix_host_id,         :kind_of => Integer
attribute :zabbix_int_type,        :kind_of => Integer, :default => 1
attribute :zabbix_int_main,        :kind_of => Integer, :default => 1
attribute :zabbix_int_useip,       :kind_of => Integer, :default => 0
attribute :zabbix_host_ip,         :kind_of => String, :default => "127.0.0.1"
attribute :zabbix_host_dns,        :kind_of => String, :default => "localhost"
attribute :zabbix_int_port,        :kind_of => Integer, :default => 10050
attribute :zabbix_user,            :kind_of => String
attribute :zabbix_url,             :kind_of => String
attribute :zabbix_password,        :kind_of => String
attribute :groups,                 :kind_of => [ String, Array ]
attribute :templates,              :kind_of => [ String, Array ]
