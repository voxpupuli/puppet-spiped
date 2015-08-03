define spiped::tunnel::server(
  $source,
  $dest,
  $secret,
) {
  spiped::tunnel { $title:
    type   => 'server',
    source => $source,
    dest   => $dest,
    secret => $secret;
  }
}
