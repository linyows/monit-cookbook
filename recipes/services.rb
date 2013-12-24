# Cookbook Name:: monit
# Recipe:: services

Array(node['monit']['services']).each do |name, attr|
  monit_service name do
    action :create

    check_type    attr['check_type'].to_sym
    check_with    attr['check_with']
    alerts        Array(attr['alerts'])

    start_program attr['start_program']
    start_with    attr['start_with']
    stop_program  attr['stop_program']
    program_uid   attr['program_uid']
    program_gid   attr['program_uid']

    group         attr['group']
    conditions    attr['conditions']
  end if attr
end

monit_service 'delete unmonitored service confs' do
  action :delete_unmonitored
  except node['monit']['services'].keys.map { |service| "#{service}.conf" }
end unless node['monit']['services'].empty?
