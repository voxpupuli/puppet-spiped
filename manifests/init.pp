# @summary Installs spiped
#
# @example Specifying a custom package
#   class { 'spiped':
#     package_source => '/path/to/spiped-1.6.git.20160201-2.el7.centos.x86_64.rpm',
#   }
#
# @see https://www.tarsnap.com/spiped.html
#
# @param package_source
#   Specifies a source to be passed to the package resource.  Typically, the path to a .deb or .rpm package file.
#
class spiped(
  Optional[String[1]] $package_source = undef,
)
{
  if $package_source {
    $package_provider = $facts['os']['family'] ? {
      'RedHat' => 'rpm',
      'Debian' => 'dpkg',
    }
  } else {
    $package_provider = undef
  }

  package { 'spiped':
    ensure   => present,
    provider => $package_provider,
    source   => $package_source,
  }

  file { '/etc/spiped':
    ensure => directory,
  }
}
