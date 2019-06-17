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
