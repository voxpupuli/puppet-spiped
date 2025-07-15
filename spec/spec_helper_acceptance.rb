require 'voxpupuli/acceptance/spec_helper_acceptance'

# The default is to call install_module which only installs modules to a master
# We need modules on agents as well.
configure_beaker(modules: :metadata) do |host|
  install_package(host, 'redis-server')
  install_package(host, 'redis-tools')
end

require 'beaker_puppet_helpers'
