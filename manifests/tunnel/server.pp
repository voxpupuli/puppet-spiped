# @summary
#   Creates and manages the server side of a spiped tunnel.
#
# @example Define a server tunnel for connecting to a local redis server
#   spiped::tunnel::server { 'redis':
#     source_host        => '0.0.0.0',
#     source_port        => 1234,
#     target_socket_file => '/var/run/redis.sock',
#     secret             => 'hunter2', # You should use a much stronger/longer secret.
#   }
#
# @param secret An arbitrarily-long shared symmetric key.  For full strength encryption, this string should contain 256 bits or more of entropy.
# @param source_socket_file Unix domain socket file on which spiped should listen for incoming connections.  If specified, `source_host` and `source_port` should not be used.
# @param source_host hostname or IP address that spiped should listen on. If specified, `source_port` is also required.
# @param source_port TCP port that spiped should listen on.  Used in conjuction with `source_host`.
# @param target_socket_file Unix domain socket file to which spiped should connect. If specified, `target_host` and `target_port` should not be used.
# @param target_host hostname or IP address that spiped should connect to. If specified, `target_port` is also required.
# @param target_port TCP port that spiped should connect to.
#
define spiped::tunnel::server (
  Variant[Sensitive[String[1]],String[1]] $secret,

  Optional[Stdlib::Unixpath] $source_socket_file = undef,
  Optional[Stdlib::Host]     $source_host = undef,
  Optional[Stdlib::Port]     $source_port = undef,

  Optional[Stdlib::Unixpath] $target_socket_file = undef,
  Optional[Stdlib::Host]     $target_host = undef,
  Optional[Stdlib::Port]     $target_port = undef,
) {
  spiped::tunnel { $title:
    type               => 'server',
    source_socket_file => $source_socket_file,
    source_host        => $source_host,
    source_port        => $source_port,
    target_socket_file => $target_socket_file,
    target_host        => $target_host,
    target_port        => $target_port,
    secret             => $secret,
  }
}
