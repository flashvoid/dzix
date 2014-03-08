include Dzix

# Support whyrun
def whyrun_supported?
  true
end

action :register do
  data = {
      :host => new_resource.name,
      :interfaces => [
        :type => new_resource.zabbix_int_type,
        :main => new_resource.zabbix_int_main,
        :ip => new_resource.zabbix_host_ip,
        :dns => new_resource.zabbix_host_dns,
        :port => new_resource.zabbix_int_port,
        :useip => new_resource.zabbix_int_useip
      ],
      :groups => [ :groupid => dzix.hostgroups.get_id(:name => new_resource.groups) ],
   }
  unless new_resource.parameters.nil?
    Chef::Log.debug("Merging parameters into data")
    data=data.merge(new_resource.parameters)
  end
  create_host(
    data
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

def create_host(data)
  if !Chef::Config[:solo] and node["zabbix"]["hostid"]
    Chef::Log.info("Host already exists as hostid = #{node["zabbix"]["hostid"]}")
  else
    hostid = dzix.hosts.create(
      data
    )
    node.set["zabbix"]["hostid"] = hostid
    if !Chef::Config[:solo] 
      node.save
    end
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
