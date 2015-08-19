define spiped::tunnel(
  $type,
  $source,
  $dest,
  $secret,
) {
  ensure_resource('package', 'spiped', {'ensure' => 'present'})
  ensure_resource('file', '/etc/spiped', {'ensure' => 'directory'})

  $unitfile = "/lib/systemd/system/spiped-${title}.service"
  $keyfile = "/etc/spiped/${title}.key"

  file {
    $unitfile:
      owner   => root,
      group   => root,
      content => template('spiped/service.erb'),
      require => File[$keyfile];

    $keyfile:
      owner     => root,
      group     => root,
      mode      => '0600',
      show_diff => false,
      content   => $secret,
      require   => File['/etc/spiped'];
  }

  exec { "start-spiped-${title}":
    command     => "systemctl daemon-reload && systemctl restart spiped-${title}",
    require     => File[$unitfile],
    subscribe   => File[$unitfile],
    refreshonly => true;
  }

  service { $title:
    ensure    => running,
    enable    => true,
    require   => [File[$unitfile], Exec["start-spiped-${title}"]],
    subscribe => File[$unitfile];
  }
}
