# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`spiped`](#spiped): Installs spiped

### Defined types

#### Public Defined types

* [`spiped::tunnel::client`](#spiped--tunnel--client): Creates and manages the client side of a spiped tunnel.
* [`spiped::tunnel::server`](#spiped--tunnel--server): Creates and manages the server side of a spiped tunnel.

#### Private Defined types

* `spiped::tunnel`

## Classes

### <a name="spiped"></a>`spiped`

Installs spiped

* **See also**
  * https://www.tarsnap.com/spiped.html

#### Examples

##### Specifying a custom package

```puppet
class { 'spiped':
  package_source => '/path/to/spiped-1.6.git.20160201-2.el7.centos.x86_64.rpm',
}
```

#### Parameters

The following parameters are available in the `spiped` class:

* [`package_source`](#-spiped--package_source)

##### <a name="-spiped--package_source"></a>`package_source`

Data type: `Optional[String[1]]`

Specifies a source to be passed to the package resource.  Typically, the path to a .deb or .rpm package file.

Default value: `undef`

## Defined types

### <a name="spiped--tunnel--client"></a>`spiped::tunnel::client`

Creates and manages the client side of a spiped tunnel.

#### Examples

##### Define a client tunnel for connecting to a remote redis server over an spiped tunnel.

```puppet
spiped::tunnel::client { 'redis':
  source_socket_file => '/var/run/redis.sock',
  target_host        => 'redis-host'
  target_port        => 1234,
  secret             => 'hunter2', # You should use a much stronger/longer secret.
}
```

#### Parameters

The following parameters are available in the `spiped::tunnel::client` defined type:

* [`secret`](#-spiped--tunnel--client--secret)
* [`source_socket_file`](#-spiped--tunnel--client--source_socket_file)
* [`source_host`](#-spiped--tunnel--client--source_host)
* [`source_port`](#-spiped--tunnel--client--source_port)
* [`target_socket_file`](#-spiped--tunnel--client--target_socket_file)
* [`target_host`](#-spiped--tunnel--client--target_host)
* [`target_port`](#-spiped--tunnel--client--target_port)

##### <a name="-spiped--tunnel--client--secret"></a>`secret`

Data type: `Variant[Sensitive[String[1]],String[1]]`

An arbitrarily-long shared symmetric key.  For full strength encryption, this string should contain 256 bits or more of entropy.

##### <a name="-spiped--tunnel--client--source_socket_file"></a>`source_socket_file`

Data type: `Optional[Stdlib::Unixpath]`

Unix domain socket file on which spiped should listen for incoming connections.  If specified, `source_host` and `source_port` should not be used.

Default value: `undef`

##### <a name="-spiped--tunnel--client--source_host"></a>`source_host`

Data type: `Optional[Stdlib::Host]`

hostname or IP address that spiped should listen on. If specified, `source_port` is also required.

Default value: `undef`

##### <a name="-spiped--tunnel--client--source_port"></a>`source_port`

Data type: `Optional[Stdlib::Port]`

TCP port that spiped should listen on.  Used in conjuction with `source_host`.

Default value: `undef`

##### <a name="-spiped--tunnel--client--target_socket_file"></a>`target_socket_file`

Data type: `Optional[Stdlib::Unixpath]`

Unix domain socket file to which spiped should connect. If specified, `target_host` and `target_port` should not be used.

Default value: `undef`

##### <a name="-spiped--tunnel--client--target_host"></a>`target_host`

Data type: `Optional[Stdlib::Host]`

hostname or IP address that spiped should connect to. If specified, `target_port` is also required.

Default value: `undef`

##### <a name="-spiped--tunnel--client--target_port"></a>`target_port`

Data type: `Optional[Stdlib::Port]`

TCP port that spiped should connect to.

Default value: `undef`

### <a name="spiped--tunnel--server"></a>`spiped::tunnel::server`

Creates and manages the server side of a spiped tunnel.

#### Examples

##### Define a server tunnel for connecting to a local redis server

```puppet
spiped::tunnel::server { 'redis':
  source_host        => '0.0.0.0',
  source_port        => 1234,
  target_socket_file => '/var/run/redis.sock',
  secret             => 'hunter2', # You should use a much stronger/longer secret.
}
```

#### Parameters

The following parameters are available in the `spiped::tunnel::server` defined type:

* [`secret`](#-spiped--tunnel--server--secret)
* [`source_socket_file`](#-spiped--tunnel--server--source_socket_file)
* [`source_host`](#-spiped--tunnel--server--source_host)
* [`source_port`](#-spiped--tunnel--server--source_port)
* [`target_socket_file`](#-spiped--tunnel--server--target_socket_file)
* [`target_host`](#-spiped--tunnel--server--target_host)
* [`target_port`](#-spiped--tunnel--server--target_port)

##### <a name="-spiped--tunnel--server--secret"></a>`secret`

Data type: `Variant[Sensitive[String[1]],String[1]]`

An arbitrarily-long shared symmetric key.  For full strength encryption, this string should contain 256 bits or more of entropy.

##### <a name="-spiped--tunnel--server--source_socket_file"></a>`source_socket_file`

Data type: `Optional[Stdlib::Unixpath]`

Unix domain socket file on which spiped should listen for incoming connections.  If specified, `source_host` and `source_port` should not be used.

Default value: `undef`

##### <a name="-spiped--tunnel--server--source_host"></a>`source_host`

Data type: `Optional[Stdlib::Host]`

hostname or IP address that spiped should listen on. If specified, `source_port` is also required.

Default value: `undef`

##### <a name="-spiped--tunnel--server--source_port"></a>`source_port`

Data type: `Optional[Stdlib::Port]`

TCP port that spiped should listen on.  Used in conjuction with `source_host`.

Default value: `undef`

##### <a name="-spiped--tunnel--server--target_socket_file"></a>`target_socket_file`

Data type: `Optional[Stdlib::Unixpath]`

Unix domain socket file to which spiped should connect. If specified, `target_host` and `target_port` should not be used.

Default value: `undef`

##### <a name="-spiped--tunnel--server--target_host"></a>`target_host`

Data type: `Optional[Stdlib::Host]`

hostname or IP address that spiped should connect to. If specified, `target_port` is also required.

Default value: `undef`

##### <a name="-spiped--tunnel--server--target_port"></a>`target_port`

Data type: `Optional[Stdlib::Port]`

TCP port that spiped should connect to.

Default value: `undef`

