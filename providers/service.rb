# Cookbook Name:: monit
# Provider:: service

include Chef::Mixin::Monit

def whyrun_supported?
  true
end

action :create do
  converge_by "Run #{new_resource}" do
    directory new_resource.name do
      path includes_dir_path
      owner 'root'
      group 'root'
      mode 0755
      action :create
      recursive true
      not_if "ls #{includes_dir_path}"
    end

    template new_resource.name do
      path "#{includes_dir_path}/#{new_resource.name}.conf"
      cookbook 'monit'
      owner 'root'
      group 'root'
      mode 0700
      source 'service.conf.erb'
      variables(
        'name' => new_resource.name,
        'check_type' => new_resource.check_type,
        'check_with' => new_resource.check_with,
        'start_program' => new_resource.start_program,
        'start_with' => new_resource.start_with,
        'stop_program' => new_resource.stop_program,
        'program_uid' => new_resource.program_uid,
        'program_gid' => new_resource.program_gid,
        'group' => new_resource.group,
        'conditions' => Array(new_resource.conditions)
      )
      notifies :restart, 'service[monit]'
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  converge_by "Run #{new_resource}" do
    file new_resource.name do
      path "#{includes_dir_path}/#{new_resource.name}.conf"
      action :delete
      notifies :restart, 'service[monit]'
    end
  end
end

action :delete_unmonitored do
  converge_by "Run #{new_resource}" do
    if includes_files
      includes_files.map { |file_name|
        file_name unless new_resource.except.include? file_name
      }.compact.each { |file_name|
        file_path = "#{includes_dir_path}/#{file_name}"
        file file_path do
          action :delete
          notifies :restart, 'service[monit]'
        end
        Chef::Log.info "delete #{file_path}"
      }
    else
      Chef::Log.info 'unmonitored service is not there - nothing to do'
    end

    new_resource.updated_by_last_action(true)
  end
end
