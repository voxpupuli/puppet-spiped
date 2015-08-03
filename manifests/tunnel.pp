define spiped::tunnel(
  $type,
  $source,
  $dest,
  $secret,
) {
  ensure_resource('package', 'spiped', {'ensure' => 'present'})

  $unitfile = "/lib/systemd/system/spiped-${title}.service"
  $keyfile = "/etc/spiped/${title}.key"

  file {
    $unitfile:
      owner   => root,
      group   => root,
      content => templates('spiped/service.erb');

    $keyfile:
      owner   => root,
      group   => root,
      mode    => '0600',
      content => $secret;
  }

  service { $title:
    require   => File[$unitfile],
    subscribe => File[$unitfile];
  }

  # We don't want to ensure it's running, lest we interfere with manual admin
  # config. We do want to start it once, though.
  exec { "start-spiped-${title}":
    command     => "systemctl start spiped-${title}",
    require     => File[$unitfile],
    subscribe   => File[$unitfile],
    refreshonly => true;
  }
}
