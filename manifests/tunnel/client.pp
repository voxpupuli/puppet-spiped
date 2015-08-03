define spiped::tunnel::client(
  $source,
  $dest,
  $secret,
) {
  spiped::tunnel { $title:
    type   => 'client',
    source => $source,
    dest   => $dest,
    secret => $secret;
  }
}
