module Dzix
      def dzix
        begin
          require 'zabbixapi'
        rescue LoadError
          Chef::Log.error("Missing gem 'zabbixapi'. Use the default aws recipe to install it first.")
        end

        @@dzix ||= ZabbixApi.new(:url => new_resource.zabbix_url, :user => new_resource.zabbix_user, :password => new_resource.zabbix_password, :debug => new_resource.zabbix_debug)
      end
end
