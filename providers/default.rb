# Cookbook Name:: monit
# Provider:: default

include Chef::Mixin::Monit

def whyrun_supported?
  true
end

action :enable do
  converge_by "Run #{new_resource}" do
    package 'monit'

    if platform?('ubuntu')
      cookbook_file '/etc/default/monit' do
        source 'monit.default'
        owner 'root'
        group 'root'
        mode 0644
      end

      # Working init script, fix for: https://bugs.launchpad.net/ubuntu/+source/monit/+bug/993381
      cookbook_file '/etc/init.d/monit' do
        source 'init-monit-ubuntu12.sh'
        owner 'root'
        group 'root'
        mode 0755
        only_if { node['platform_version'].to_i == 12 }
      end
    end

    service 'monit' do
      supports :start => true, :restart => true, :stop => true
      action [:enable, :start]
    end

    directory includes_dir_path do
      owner 'root'
      group 'root'
      mode 0755
      action :create
      recursive true
    end

    directory new_resource.eventqueue_basedir do
      owner 'root'
      group 'root'
      mode 0755
      action :create
      recursive true
    end

    template conf_path do
      path conf_path
      cookbook 'monit'
      owner 'root'
      group 'root'
      mode 0700
      source 'monit.conf.erb'
      variables(
        'name' => new_resource.name,
        'poll_interval' => new_resource.poll_interval,
        'poll_start_delay' => new_resource.poll_start_delay,
        'logfile' => new_resource.logfile,
        'idfile' => new_resource.idfile,
        'statefile' => new_resource.statefile,
        'smtp_servers' => Array(new_resource.smtp_servers),
        'eventqueue_basedir' => new_resource.eventqueue_basedir,
        'eventqueue_slots' => new_resource.eventqueue_slots,
        'httpd' => new_resource.httpd,
        'httpd_host' => new_resource.httpd_host,
        'httpd_port' => new_resource.httpd_port,
        'httpd_allows' => new_resource.httpd_allows,
        'notification_emails' => Array(new_resource.notification_emails),
        'notification_from' => new_resource.notification_from,
        'notification_subject' => new_resource.notification_subject,
        'notification_message' => new_resource.notification_message,
        'includes_dir_path' => includes_dir_path
      )
      notifies :restart, 'service[monit]'
    end

    new_resource.updated_by_last_action(true)
  end
end

action :disable do
  converge_by "Run #{new_resource}" do
    package 'monit'

    service 'monit' do
      supports :status => true, :start => true, :stop => true, :restart => true
      action [:disable, :stop]
    end
  end
end
