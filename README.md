puppet-spiped
========

[![License](https://img.shields.io/github/license/voxpupuli/puppet-spiped.svg)](https://github.com/voxpupuli/puppet-spiped/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-spiped.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-spiped)

Puppet module for configuring [spiped][spiped] tunnels.

## Requirements

* Debian >= 8 / Ubuntu >= 16.04 or similar systems that provide an `spiped` package.
* systemd as init

### RedHat systems

This module can also work with RedHat systems, but you are responsible for providing the spiped package.

Either use the `package_source` parameter, or make sure your system has a repository setup that includes
the `spiped` package.

eg.

```puppet
class { 'spiped':
  package_source => '/path/to/spiped.rpm',
}
```

or

```puppet
yumrepo { 'spiped':
  baseurl => 'http://repos.example.com/spiped',
  descr   => 'Internal spiped package repo',
  enabled => true,
  before  => Class['spiped'],
}
```

## Usage

For example, let's say we have a host `redis-host` which hosts a Redis
database. Many clients will connect to it.

On `redis-host`, we would define a server tunnel:

```puppet
spiped::tunnel::server { 'redis':
  source_host        => '0.0.0.0',
  source_port        => 1234,
  target_socket_file => '/var/run/redis.sock',
  secret             => 'hunter2',
}
```

On clients, we would define a client tunnel:

```puppet
spiped::tunnel::client { 'redis':
  source_socket_file => '/var/run/redis.sock',
  target_host        => 'redis-host'
  target_port        => 1234',
  secret             => 'hunter2',
}
```

The secret is an arbitrarily-long shared symmetric key. The options above are
the only supported; this module is kept as simple as possible.

[spiped]: https://www.tarsnap.com/spiped.html
