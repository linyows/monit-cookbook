# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  cookbooks_path = %w(cookbooks vendor/cookbooks)

  config.vm.define :centos do |centos|
    centos.vm.box = 'CentOS_6.4-Chef_11.4.4'
    centos.vm.box_url = 'http://goo.gl/GZqvsF'
    centos.vm.hostname = 'centos'
    centos.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = cookbooks_path
      chef.add_recipe 'postfix'
      chef.add_recipe 'memcached'
      chef.add_recipe 'yum::epel'
      chef.add_recipe 'monit'
      chef.json = {
        :monit => {
          :poll_interval => 10,
          :poll_start_delay => 0,
          :alerts => 'linyows@gmail.com',
          :logfile => '/var/log/monit.log',
          :services => {
            :ssh => {
              :check_type => :process,
              :check_with => 'pidfile /var/run/sshd.pid',
              :start_program => '/etc/init.d/sshd start',
              :start_with => 'timeout 10 seconds',
              :stop_program => '/etc/init.d/sshd stop',
              :conditions => [
                'if failed port 22 protocol ssh then restart',
                'if 5 restarts within 5 cycles then timeout'
              ]
            },
            :memcache => {
              :check_type => :process,
              :check_with => 'pidfile /var/run/memcached/memcached.pid',
              :start_program => '/etc/init.d/memcached start',
              :start_with => 'timeout 60 seconds',
              :stop_program => '/etc/init.d/memcached stop',
              :conditions => [
                'if failed host 127.0.0.1 port 11211 then restart',
                'if 2 restarts within 3 cycles then timeout',
                'if cpu > 70% for 2 cycles then alert',
                'if cpu > 98% for 5 cycles then restart'
              ]
            }
          }
        }
      }
    end
  end

  config.vm.define :ubuntu do |ubuntu|
    ubuntu.vm.box = 'Ubuntu_12.04-Chef_11.4.4'
    ubuntu.vm.box_url = 'http://goo.gl/np92o'
    ubuntu.vm.hostname = 'ubuntu'
    ubuntu.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = cookbooks_path
      chef.add_recipe 'postfix'
      chef.add_recipe 'memcached'
      chef.add_recipe 'monit'
      chef.json = {
        :monit => {
          :poll_interval => 30,
          :poll_start_delay => 0,
          :alerts => 'linyows@gmail.com',
          :services => {
            :ssh => {
              :check_type => :process,
              :check_with => 'pidfile /var/run/sshd.pid',
              :start_program => '/etc/init.d/ssh start',
              :start_with => 'timeout 10 seconds',
              :stop_program => '/etc/init.d/ssh stop',
              :conditions => [
                'if failed port 22 protocol ssh then restart',
                'if 5 restarts within 5 cycles then timeout'
              ]
            },
            :memcache => {
              :check_type => :process,
              :check_with => 'pidfile /var/run/memcached.pid',
              :start_program => '/etc/init.d/memcached start',
              :start_with => 'timeout 60 seconds',
              :stop_program => '/etc/init.d/memcached stop',
              :conditions => [
                'if failed host 127.0.0.1 port 11211 protocol memcache then restart',
                'if 2 restarts within 3 cycles then timeout',
                'if cpu > 70% for 2 cycles then alert',
                'if cpu > 98% for 5 cycles then restart'
              ]
            }
          }
        }
      }
    end
  end
end
