class Chef
  module Mixin
    module Monit
      include Chef::Mixin::ShellOut

      def conf_path
        case node['platform_family']
        when 'rhel', 'fedora', 'suse' then '/etc/monit.conf'
        else '/etc/monit/monitrc'
        end
      end

      def includes_dir_path
        case node['platform_family']
        when 'rhel', 'fedora', 'suse' then '/etc/monit.d'
        else '/etc/monit/conf.d'
        end
      end

      def includes_files
        out = shell_out("ls #{includes_dir_path}")
        out.stdout.split("\n") if out.exitstatus.zero?
      end
    end
  end
end
