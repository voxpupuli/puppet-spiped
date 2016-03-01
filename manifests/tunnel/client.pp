define spiped::tunnel::client(
  $source,
  $dest,
  $secret,
  $user,
) {
  spiped::tunnel { $title:
    type   => 'client',
    source => $source,
    dest   => $dest,
    secret => $secret,
    user => $user;
  }
}
