# backupninja

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/soli/backupninja.svg)](https://forge.puppetlabs.com/soli/backupninja)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/soli/backupninja.svg)](https://forge.puppetlabs.com/soli/backupninja)
[![Puppet Forge Score](http://img.shields.io/puppetforge/f/soli/backupninja.svg)](https://forge.puppetlabs.com/soli/backupninja)
[![Build Status](https://travis-ci.org/solution-libre/puppet-backupninja.svg?branch=master)](https://travis-ci.org/solution-libre/puppet-backupninja)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with backupninja](#setup)
    * [Beginning with backupninja](#beginning-with-backupninja)
3. [Usage - Configuration options and additional functionality](#usage)
    * [Install header packages](#install-header-packages)
    * [Install all headers packages and the documentation](#install-all-headers-packages-and-the-documentation)
    * [Uninstall a backupninja library](#uninstall-a-backupninja-library)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors](#contributors)

## Module Description

This module installs and configures [backupninja](https://labs.riseup.net/code/projects/backupninja).

## Setup

### Beginning with backupninja

## Usage

Configure your backup server
----------------------------

Now you will need to configure a backup server by adding the following
to your node definition for that server:

  include backupninja::server

By configuring a backupninja::server, this module will automatically
create sandboxed users on the server for each client for their
backups.

You may also want to set some variables on your backup server, such as:

  $backupdir = "/backups"


Configure your backup clients
-----------------------------

The backupninja package and the necessary backup software will be
installed automatically when you include any of the different handlers
(as long as you are not handling it elsewhere in your manifests), for
example:

include backupninja::client::rdiff_backup

In this case, the module will make sure that the backupninja package
and the required rdiff-backup package are 'installed'/'present' (using
puppet's ensure parameter language). If you need to specify a specific
version of either backupninja itself, or the specific programs that
the handler class installs, you can specify the version you need
installed by providing a variable, for example:

$backupninja_ensure_version = "0.9.7~bpo50+1"
$rdiff_backup_ensure_version = "1.2.5-1~bpo40+1"
$rsync_ensure_version = "3.0.6-1~bpo50+1"
$duplicity_ensure_version = "0.6.04-1~bpo50+1"
$debconf_utils_ensure_version = "1.5.28"
$hwinfo_ensure_version = "16.0-2"

If you do not specify these variables the default 'installed/present'
version will be installed when you include this class.

Configuring handlers
--------------------

Depending on which backup method you want to use on your client, you
can simply specify some configuration options for that handler that are
necessary for your client.

Each handler has its own configuration options necessary to make it
work, each of those are available as puppet parameters. You can see
the handler documentation, or look at the handler puppet files
included in this module to see your different options.

Included below are some configuration examples for different handlers.

* An example mysql handler configuration:

backupninja::mysql { all_databases:
	user => root,
	backupdir => '/var/backups',
	compress => true,
	sqldump => true
}

* An example rdiff-backup handler configuration:

backupninja::rdiff { backup_all:
	directory => '/media/backupdisk',
	include => ['/var/backups', '/home', '/var/lib/dpkg/status'],
	exclude => '/home/\*/.gnupg'
}

* A remote rdiff-backup handler:

    backupninja::rdiff { "main":
        host => "backup.example.com",
        type => "remote",
        directory => "/backup/$fqdn",
        user => "backup-$hostname",
    }


Configuring backupninja itself
------------------------------

You may wish to configure backupninja itself. You can do that by doing
the following, and the /etc/backupninja.conf will be managed by
puppet, all the backupninja configuration options are available, you
can find them inside this module as well.

For example:

backupninja::config { conf:
	loglvl => 3,
	usecolors => false,
	reportsuccess => false,
	reportwarning => true;
}


Nagios alerts about backup freshness
------------------------------------

If you set the $nagios_server variable to be the name of your nagios
server, then a passive nagios service gets setup so that the backup
server pushes checks, via a cronjob that calls
/usr/local/bin/checkbackups.pl, to the nagios server to alert about
relative backup freshness.

To use this feature a few pre-requisites are necessary:

 . configure nsca on your backup server (not done via puppet yet)
 . configure nsca on your nagios server (not done via puppet yet)
 . server backup directories are named after their $fqdn
 . using nagios2 module, nagios/nagios3 modules/nativetypes not supported yet
 . using a nagios puppet module that can create passive service checks
 . backups must be under $home/dup, $home/rdiff-backup depending on method
 . $nagios_server must be set before the class is included

 ## Reference

 ### Classes

 #### Public Classes

 ## Limitations

 RedHat and Debian family OSes are officially supported. Tested and built on Debian and CentOS.

 ## Development

 [Solution Libre](https://www.solution-libre.fr) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

 [Fork this module on GitHub](https://github.com/solution-libre/puppet-backupninja/fork)

 ## Contributors

 The list of contributors can be found at: https://github.com/solution-libre/puppet-backupninja/graphs/contributors
