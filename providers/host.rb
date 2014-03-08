include Dzix

# Support whyrun
def whyrun_supported?
  true
end

action :register do
  create_host(
    new_resource.name,
    new_resource.zabbix_debug,
    new_resource.zabbix_user,
    new_resource.zabbix_url,
    new_resource.zabbix_password,
    new_resource.groups,
    new_resource.zabbix_int_type,
    new_resource.zabbix_int_main,
    new_resource.zabbix_host_ip,
    new_resource.zabbix_host_dns,
    new_resource.zabbix_int_port,
    new_resource.zabbix_int_useip,
    new_resource.parameters,
  )
end

action :linktemplates do
  link_templates(
    new_resource.zabbix_debug,
    new_resource.zabbix_user,
    new_resource.zabbix_url,
    new_resource.zabbix_password,
    new_resource.zabbix_host_id,
    new_resource.templates,
  )
end

action :deregister do
  deregister_host(
    new_resource.zabbix_debug,
    new_resource.zabbix_user,
    new_resource.zabbix_url,
    new_resource.zabbix_password,
  )
end


private

def deregister_host(zabbix_debug, zabbix_user, zabbix_url, zabbix_password)
  if node["zabbix"].attribute?("hostid")
    Chef::Log.info("Deregistering host hostid = #{node["zabbix"]["hostid"]}")
    dzix.hosts.delete({ "hostid" => node["zabbix"]["hostid"].to_s })
  else
    Chef::Log.info("Host is not regestered in zabbix, skipping decomission routine")
  end
end

def create_host(name, zabbix_debug, zabbix_user, zabbix_url, zabbix_password, groups, zabbix_int_type, zabbix_int_main, zabbix_host_ip, zabbix_host_dns, zabbix_int_port, zabbix_int_useip, parameters)
  if node["zabbix"]["hostid"]
    Chef::Log.info("Host already exists as hostid = #{node["zabbix"]["hostid"]}")
  else
    hostid = dzix.hosts.create(
      :host => name,
      :interfaces => [
        :type => zabbix_int_type,
        :main => zabbix_int_main,
        :ip => zabbix_host_ip,
        :dns => zabbix_host_dns,
        :port => zabbix_int_port,
        :useip => zabbix_int_useip
      ],
      :groups => [ :groupid => dzix.hostgroups.get_id(:name => groups) ],
      parameters
    )
    node.set["zabbix"]["hostid"] = hostid
    node.save
  end
end

def link_templates(zabbix_debug, zabbix_user, zabbix_url, zabbix_password, zabbix_host_id, templates)
  zabbix_host_id ||= node["zabbix"]["hostid"]

  tmpl = get_templates_ids(templates)
  Chef::Log.info("Template names resolved to ids = #{tmpl}")
  
  dzix.templates.mass_add(
    :hosts_id => [ zabbix_host_id ],
    :templates_id => tmpl,
  )
end

def get_templates_ids(templates)
  res=[]
  templates.each do |tmpl|
    res << dzix.query(:method => "template.get", :params => { 'filter' => { 'host' => [ tmpl ] } } )[0]["templateid"]
  end
  res
end
