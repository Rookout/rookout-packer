require 'serverspec'
require 'net/ssh'

host = ENV['HOST']

set :backend, :ssh

options = Net::SSH::Config.for(host)
options[:user] = ENV['TARGET_USER']
options[:key_data ] = ENV['HOST_KEY']

set :host,        options[:host_name] || host
set :ssh_options, options