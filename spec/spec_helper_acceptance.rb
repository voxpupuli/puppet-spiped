require 'voxpupuli/acceptance/spec_helper_acceptance'

# The default is to call install_module which only installs modules to a master
# We need modules on agents as well.
configure_beaker(modules: false) do |host|
  install_package(host, 'redis-server')
  install_package(host, 'redis-tools')
end

require 'beaker/module_install_helper'
install_module_on(hosts)
install_module_dependencies_on(hosts)
