define spiped::tunnel::server(
  $source,
  $dest,
  $secret,
  $user,
) {
  spiped::tunnel { $title:
    type   => 'server',
    source => $source,
    dest   => $dest,
    secret => $secret,
    user => $user;
  }
}
