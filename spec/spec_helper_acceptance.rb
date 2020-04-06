require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_package(host, 'redis-server')
  install_package(host, 'redis-tools')
end
