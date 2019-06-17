puppet-spiped
========

[![License](https://img.shields.io/github/license/voxpupuli/puppet-spiped.svg)](https://github.com/voxpupuli/puppet-spiped/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/voxpupuli/puppet-spiped.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-spiped)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/spiped.svg)](https://forge.puppetlabs.com/puppet/spiped)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/spiped.svg)](https://forge.puppetlabs.com/puppet/spiped)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/spiped.svg)](https://forge.puppetlabs.com/puppet/spiped)

#### Table of Contents

1. [Overview](#overview)
1. [Setup - The basics of getting started with spiped](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This puppet module is used for configuring [spiped][spiped] tunnels.
It supports recent Debian and RedHat family OSes using Puppet 5 or greater.

## Setup

### Debian family systems

Supported Debian and Ubuntu OSes provide suitable `spiped` packages and no additional setup is required.

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
  secret             => 'hunter2', # You should use a much stronger/longer secret!
}
```

On clients, we would define a client tunnel:

```puppet
spiped::tunnel::client { 'redis':
  source_socket_file => '/var/run/redis.sock',
  target_host        => 'redis-host'
  target_port        => 1234,
  secret             => 'hunter2', # You should use a much stronger/longer secret!
}
```

The secret is an arbitrarily-long shared symmetric key. For [full strength security](https://github.com/Tarsnap/spiped/tree/5c13832aeecdad8a655dadcf5413cc504ad99e49#security-requirements),
the key should contain 256 or more bits of entropy.

Reference documentation is available in [REFERENCE.md](REFERENCE.md)

## Limitations

* Only systemd based OSes are supported.
* Not all spiped options are currently configurable with this module.

## Development

This module was migrated from [ckuehl/spiped](https://forge.puppet.com/ckuehl/spiped) to [Vox Pupuli](https://voxpupuli.org)

We highly welcome new contributions to this module, especially those that
include documentation, and rspec tests ;) but will happily guide you through
the process, so, yes, please submit that pull request!

Reference documentation is generated using puppet-strings.
To regenerate it, please run the rake task as follows.

```console
bundle exec rake reference
```

[spiped]: https://www.tarsnap.com/spiped.html
