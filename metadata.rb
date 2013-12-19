name             'monit'
maintainer       'linyows'
maintainer_email 'linyows@gmail.com'
license          'MIT'
description      'Installs/Configures monit'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

recipe 'monit', 'Installs and configuires monit'
recipe 'monit::disabled', 'disable monit'

%w(centos redhat fedora ubuntu debian).each { |os| supports os }
