# Cookbook Name:: monit
# Recipe:: default

monit 'all' do
  action :enable
  poll_interval        node['monit']['poll_interval'].to_i
  poll_start_delay     node['monit']['poll_start_delay'].to_i

  logfile              node['monit']['logfile']
  idfile               node['monit']['idfile']
  statefile            node['monit']['statefile']

  smtp_servers         Array(node['monit']['smtp_servers'])

  eventqueue_basedir   node['monit']['eventqueue_basedir']
  eventqueue_slots     node['monit']['eventqueue_slots'].to_i

  httpd                node['monit']['httpd']
  httpd_host           node['monit']['httpd_host']
  httpd_port           node['monit']['httpd_port']
  httpd_allows         Array(node['monit']['httpd_allows'])

  notification_emails  Array(node['monit']['notification_emails'])
  notification_from    node['monit']['notification_from']
  notification_subject node['monit']['notification_subject']
  notification_message node['monit']['notification_message']
end

include_recipe 'monit::services'
