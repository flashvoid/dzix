module Dzix
      def dzix
        begin
          require 'zabbixapi'
        rescue LoadError
          Chef::Log.error("Missing gem 'zabbixapi'. Use the default aws recipe to install it first.")
        end

        begin
          @@dzix.query(:method=>"apiinfo.version", :params => { } )
        rescue
          @@dzix = init
        end

        @@dzix ||= init
      end

      def init
         @@init = ZabbixApi.new(:url => new_resource.zabbix_url, :user => new_resource.zabbix_user, :password => new_resource.zabbix_password, :debug => new_resource.zabbix_debug)
      end
end
