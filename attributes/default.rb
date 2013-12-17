# Cookbook Name:: monit
# Attributes:: default

default['monit']['poll_interval']        = 120
default['monit']['poll_start_delay']     = 300
default['monit']['smtp_servers']         = 'localhost'
default['monit']['eventqueue_slots']     = 100
default['monit']['httpd']                = false
default['monit']['httpd_host']           = 'localhost'
default['monit']['httpd_port']           = 2812
default['monit']['httpd_allows']         = [
  'localhost',
  '192.168.0.1/24',
  'admin:monit',
  'user:pass read-only'
]
default['monit']['notification_emails']  = 'admin@example.com but not on { action }'
default['monit']['notification_from']    = 'monit@$HOST'
default['monit']['notification_subject'] = '[Monit Alert] $HOST: $EVENT $SERVICE'
default['monit']['notification_message'] = <<-MSG.gsub(/^ {2}/, '').strip
  $EVENT Service $SERVICE

  Date: $DATE
  Action: $ACTION
  Host: $HOST
  Description: $DESCRIPTION

  Your faithful employee,
  Monit
MSG

case node['platform_family']
when 'rhel', 'fedora', 'suse'
  default['monit']['logfile']              = 'syslog facility log_daemon'
  default['monit']['idfile']               = '/var/monit.id'
  default['monit']['statefile']            = '/var/monit.state'
  default['monit']['eventqueue_basedir']   = '/var/monit'
else
  default['monit']['logfile']              = '/var/log/monit.log'
  default['monit']['idfile']               = '/var/lib/monit/id'
  default['monit']['statefile']            = '/var/lib/monit/state'
  default['monit']['eventqueue_basedir']   = '/var/lib/monit/events'
end
