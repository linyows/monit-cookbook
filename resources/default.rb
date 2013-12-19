# Cookbook Name:: monit
# Resource:: default

actions :enable, :disable, :start, :stop
default_action :enable

def initialize(*args)
  super
  @action = :enable
end

attribute :name,
  :name_attribute => true,
  :kind_of => String
attribute :service,
  :name_attribute => true,
  :kind_of => String
attribute :poll_interval,
  :kind_of => Integer,
  :default => 15
attribute :poll_start_delay,
  :kind_of => Integer,
  :default => 60
attribute :logfile,
  :kind_of => String,
  :required => true
attribute :idfile,
  :kind_of => String,
  :required => true
attribute :statefile,
  :kind_of => String,
  :required => true
attribute :smtp_servers,
  :kind_of => [String, Array],
  :default => 'localhost'
attribute :eventqueue_basedir,
  :kind_of => String,
  :required => true
attribute :eventqueue_slots,
  :kind_of => Integer,
  :default => 5000
attribute :httpd,
  :kind_of => [TrueClass, FalseClass],
  :default => true
attribute :httpd_host,
  :kind_of => String,
  :default => 'localhost'
attribute :httpd_port,
  :kind_of => Integer,
  :default => 2812
attribute :httpd_allows,
  :kind_of => Array,
  :default => [
    'localhost',
    '192.168.0.1/24',
    'admin:monit',
    'user:pass read-only'
  ]
attribute :notification_emails,
  :kind_of => [String, Array],
  :default => 'admin@example.com not on { action }'
attribute :notification_from,
  :kind_of => String,
  :default => 'monit@$HOST'
attribute :notification_subject,
  :kind_of => String,
  :default => '[Monit Alert] $HOST: $EVENT $SERVICE'
attribute :notification_message,
  :kind_of => String,
  :default => <<-MSG.gsub(/^ {4}/, '').strip
    $EVENT Service $SERVICE

    Date:        $DATE
    Action:      $ACTION
    Host:        $HOST
    Description: $DESCRIPTION

    Your faithful employee,
    Monit
  MSG
