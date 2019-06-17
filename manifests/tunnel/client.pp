define spiped::tunnel::client(
  Variant[Sensitive[String[1]],String[1]] $secret,

  Optional[Stdlib::Unixpath] $source_socket_file = undef,
  Optional[Stdlib::Host]     $source_host = undef,
  Optional[Stdlib::Port]     $source_port = undef,

  Optional[Stdlib::Unixpath] $target_socket_file = undef,
  Optional[Stdlib::Host]     $target_host = undef,
  Optional[Stdlib::Port]     $target_port = undef,
)
{
  spiped::tunnel { $title:
    type               => 'client',
    source_socket_file => $source_socket_file,
    source_host        => $source_host,
    source_port        => $source_port,
    target_socket_file => $target_socket_file,
    target_host        => $target_host,
    target_port        => $target_port,
    secret             => $secret,
  }
}
