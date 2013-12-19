Monit Cookbook
==============

[![Build Status](https://secure.travis-ci.org/linyows/monit-cookbook.png)][travis]

Installs monit and generates the configuration file.

Usage
-----

Role based monitoring example:

```ruby
run_list(
  'recipe[monit]'
)
override_attributes(
  :monit => {
    :poll_interval => 30,
    :poll_start_delay => 100,
    :notification_emails => 'admin@example.com but not on { action, instance }',
    :services => {
      :ssh => {
        :check_type => :process,
        :check_with => 'pidfile /var/run/sshd.pid',
        :start_program => '/etc/init.d/ssh start',
        :start_with => 'timeout 60 seconds',
        :stop_program => '/etc/init.d/ssh stop',
        :conditions => [
          'if failed port 22 protocol ssh then restart',
          'if 5 restarts within 5 cycles then timeout'
        ]
      },
      :memcached => {
        :check_type => :process,
        :check_with => 'pidfile /var/run/memcached.pid',
        :start_program => '/etc/init.d/memcached start',
        :start_with => 'timeout 60 seconds',
        :stop_program => '/etc/init.d/memcached stop',
        :conditions => [
          'if failed port 11211 protocol memcache then restart',
          'if 2 restarts within 3 cycles then timeout',
          'if cpu > 70% for 2 cycles then alert',
          'if cpu > 98% for 5 cycles then restart'
        ]
      }
    }
  }
)
```

Requirements
------------

- Chef >= 11.4
- Platform: ubuntu, debian, fedora, centos and redhat

Attributes
----------

### monit::default

Key                  | Description           | Default
---                  | -----------           | -------
poll_interval        | check interval        | 15
poll_start_delay     | start server delay    | 60
logfile              | log file path         | /var/log/monit.log
idfile               | id file path          | /var/lib/monit/id
statefile            | state dir path        | /var/lib/monit/state
smtp_servers         | smtp server           | localhost
eventqueue_basedir   | eventqueue basedir    | /var/lib/monit/events
eventqueue_slots     | eventqueue slots      | 5000
httpd                | enable web interface  | true
httpd_host           | web interface address | localhost
httpd_port           | web interface port    | 2812
httpd_allows         | allow access          | ['localhost', '192.168.0.1/24', 'admin:monit', 'user:pass read-only']
notification_emails  | email addresses       | admin@example.com but not on { action }
notification_from    | email from            | monit@$HOST
notification_subject | email submit          | [$HOST: monit alert] $EVENT $SERVICE
notification_message | email message         | $EVENT Service $SERVICE...
services             | services attributes   | {}

Resources / Providers
---------------------

- monit
- monit_service

### Monit Resource

example:

```ruby
monit do
  action :enable

  poll_interval 15
  poll_start_delay 60

  logfile '/var/log/monit.log'
  idfile '/var/lib/monit/id'
  statefile '/var/lib/monit/state'

  eventqueue_basedir '/var/lib/monit/events'
  eventqueue_slots 5000
end
```

### MonitService Resource

example:

```ruby
monit_service 'memcached' do
  action :create

  check_type :process
  check_with 'pidfile /var/run/memcached/memcached.pid'

  start_program '/etc/init.d/memcached start'

  start_with 'timeout 60 seconds'
  stop_program '/etc/init.d/memcached stop'

  conditions [
    'if failed host 127.0.0.1 port 11211 then restart',
    'if 2 restarts within 3 cycles then timeout',
    'if cpu > 70% for 2 cycles then alert',
    'if cpu > 98% for 5 cycles then restart'
  ]
end
```

License
-------

MIT

Authors
-------

- [@linyows][linyows]

[travis]: http://travis-ci.org/linyows/monit-cookbook
[linyows]: https://github.com/linyows
