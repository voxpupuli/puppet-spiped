define spiped::tunnel(
  $type,
  $source,
  $dest,
  $secret,
  $user
) {
  ensure_resource('package', 'spiped', {'ensure' => 'present'})
  ensure_resource('file', '/etc/spiped', {'ensure' => 'directory'})

  $keyfile = "/etc/spiped/${title}.key"

  if $::operatingsystem == 'Ubuntu' {
    $unitfile = "/etc/init/spiped-${title}.conf"
    $content = template('spiped/spiped.conf.erb')
    $command = "restart spiped-${title}"
  }
  else {
    $unitfile = "/lib/systemd/system/spiped-${title}.service"
    $content = template('spiped/service.erb')
    $command = "systemctl daemon-reload && systemctl restart spiped-${title}"
  }

  if $user {
    $owner = $user
  }
  else {
    $owner = root
  }

  file {
    $unitfile:
      owner   => root,
      group   => root,
      content => $content,
      require => File[$keyfile];

    $keyfile:
      owner     => $owner,
      group     => $owner,
      mode      => '0600',
      show_diff => false,
      content   => $secret,
      require   => File['/etc/spiped'];
  }

  exec { "start-spiped-${title}":
    command     => $command,
    require     => File[$unitfile],
    subscribe   => File[$unitfile],
    refreshonly => true;
  }

  service { "spiped-${title}":
    ensure    => running,
    enable    => true,
    require   => [File[$unitfile], Exec["start-spiped-${title}"]],
    subscribe => File[$unitfile];
  }
}
