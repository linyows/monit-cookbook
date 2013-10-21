# Cookbook Name:: monit
# Resource:: service

actions :create, :delete, :delete_unmonitored
default_action :create

def initialize(*args)
  super
  @action = :create
end

attribute :name,
  :name_attribute => true,
  :kind_of => String
attribute :check_type,
  :kind_of => Symbol,
  :equal_to => [:process, :directory, :file, :filesystem, :host, :system],
  :required => true
attribute :check_with,
  :kind_of => String,
  :required => true
attribute :group,
  :kind_of => String
attribute :start_program,
  :kind_of => String,
  :required => true
attribute :start_with,
  :kind_of => String
attribute :stop_program,
  :kind_of => String,
  :required => true
attribute :program_uid,
  :kind_of => String
attribute :program_gid,
  :kind_of => String
attribute :conditions,
  :kind_of => Array
attribute :except,
  :kind_of => [Array, String]
