define spiped::tunnel(
  $type,
  $source,
  $dest,
  $secret,
) {
  ensure_resource('package', 'spiped', {'ensure' => 'present'})
  ensure_resource('file', '/etc/spiped', {'ensure' => 'directory'})

  $keyfile = "/etc/spiped/${title}.key"

  file { $keyfile:
    owner     => root,
    group     => root,
    mode      => '0600',
    show_diff => false,
    content   => $secret,
  }

  # Previous versions created a unit file here.
  file { "/lib/systemd/system/spiped-${title}.service":
    ensure => absent,
    before => Systemd::Unit_file["spiped-${title}.service"],
  }

  systemd::unit_file { "spiped-${title}.service":
    content => template('spiped/service.erb'),
  }

  service { "spiped-${title}":
    ensure    => running,
    enable    => true,
    subscribe => Systemd::Unit_file["spiped-${title}.service"],
  }
}
