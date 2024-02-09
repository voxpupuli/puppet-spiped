require 'voxpupuli/acceptance/spec_helper_acceptance'

# The default is to call install_module which only installs modules to a master
# We need modules on agents as well.
configure_beaker(modules: false) do |host|
  install_package(host, 'redis-server')
  install_package(host, 'redis-tools')
end

require 'beaker_puppet_helpers'
install_puppet_module_via_pmt_on(hosts, 'puppetlabs/stdlib')
install_puppet_module_via_pmt_on(hosts, 'puppet/systemd')
