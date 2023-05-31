require 'serverspec'
require 'net/ssh'

host = ENV['HOST']

set :backend, :ssh
set :sudo_password, ENV['SUDO_PASSWORD']

options = Net::SSH::Config.for(host)
options[:user] = ENV['TARGET_USER']
options[:password] = ENV['TARGET_PASSWORD']
options[:keys] = ENV['HOST_KEY']

set :host,        options[:host_name] || host
set :ssh_options, options