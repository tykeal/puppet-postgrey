# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

-   [`postgrey`](#postgrey): Install and configure postgrey
-   [`postgrey::config`](#postgreyconfig): Configure postgrey
-   [`postgrey::install`](#postgreyinstall): Installs postgrey
-   [`postgrey::service`](#postgreyservice): Manages the postgrey service

## Classes

### postgrey

Install and configure postgrey

#### Examples

#####

```puppet
include ::postgrey
```

### postgrey::config

Builds postgrey configuration files from hiera data. Any parameters that
default to undef are optional and will cause postgrey to use the builtin
defaults for those settings if they exist.

#### Parameters

The following parameters are available in the `postgrey::config` class.

##### `exim`

Data type: `Boolean`

If true, sets the --exim option (default: false)

##### `delay`

Data type: `Integer[0]`

Sets the --delay option (default: 300)

##### `group`

Data type: `String[1]`

Sets the --group option (default: postgrey)

##### `lookup_by_host`

Data type: `Boolean`

If true, sets the lookup-by-host option (default: false)

##### `lookup_by_subnet`

Data type: `Boolean`

If true, sets the lookup-by-subnet option (default: false)

##### `pidfile`

Data type: `Stdlib::AbsolutePath`

The absolute filepath to where the pidfile should live.
(default: /var/run/postgrey.pid)

##### `privacy`

Data type: `Boolean`

If true, sets the --privacy option (default: true)

##### `quiet`

Data type: `Boolean`

If true, sets the --quiet option (default: true)

##### `type`

Data type: `Struct[{
      inet => Optional[Struct[{
                port => Stdlib::Port,
                host => Optional[Stdlib::Host],
              }]],
      unix => Optional[Struct[{
                socket  => Stdlib::AbsolutePath,
                mode    => Optional[Stdlib::Filemode],
              }]],
  }]`

Enables either inet or unix listening type

-   inet requires a port defined and an optional host
-   unix requires a socket path (default: /var/spool/postfix/postgrey/socket)
    and an optional socket mode
-   Only listening option may be set, the default is to use 'unix'

##### `user`

Data type: `String[1]`

Sets the --user option (default: postgrey)

##### `whitelist`

Data type: `Array[Stdlib::Host]`

An array of host type entries for the local whitelist (allowlist). This is
used to create the /etc/postfix/postgrey_whitelist_clients.local file
(default: [])

##### `whitelist_recipients`

Data type: `Array[Pattern[/\S+@/]]`

An array of left side email address (user@) to configure the local
allowlist of recipients. This sets the
/etc/postfix/postgrey_whitelist_recipients file (default: [])

##### `auto_whitelist_clients`

Data type: `Optional[Integer[0]]`

Configures the --auto-whitelist-clients option (default: undef)

Default value: `undef`

##### `greylist_action`

Data type: `Optional[String[1]]`

Configures the --greylist-action option (default: undef)

Default value: `undef`

##### `hostname`

Data type: `Optional[Stdlib::Fqdn]`

Configures the --hostname option (default: undef, postgrey will
automatically use the fqdn if this is not set)

Default value: `undef`

##### `ipv4cidr`

Data type: `Optional[Integer[0,32]]`

Configures the --ipv4cidr option (default: undef)

Default value: `undef`

##### `ipv6cidr`

Data type: `Optional[Integer[4,128]]`

Configures the --ipv6cidr option (default: undef)

Default value: `undef`

##### `listen_queue_size`

Data type: `Optional[Integer[1]]`

Configures the --listen-queue-size option (default: undef)

Default value: `undef`

##### `max_age`

Data type: `Optional[Integer[1]]`

Configures the --max-age option (default: undef)

Default value: `undef`

##### `retry_window`

Data type: `Optional[Variant[Integer[1],Regexp[/\d+h/]]]`

Configures the --retry-window option (default: undef)

Default value: `undef`

##### `syslog_facility`

Data type: `Optional[String[1]]`

Configures the --syslog-facility option (default: undef)

Default value: `undef`

##### `x_greylist_header`

Data type: `Optional[String[1]]`

Configures the --x-greylist-header option (default: undef)

Default value: `undef`

### postgrey::install

Installs postgrey using the available package

#### Parameters

The following parameters are available in the `postgrey::install` class.

##### `manage_package`

Data type: `Boolean`

If true, will ensure the postgrey package (default: true)

##### `ensure`

Data type: `String`

If true, will ensure the package as stated (default: present)
NOTE: the default makes sure it is installed, but will not upgrade unless
changed to latest!

##### `package_name`

Data type: `String`

The name of the package to install (default: postgrey)

### postgrey::service

Configures the postgrey service as defined

#### Parameters

The following parameters are available in the `postgrey::service` class.

##### `ensure`

Data type: `String`

Ensures the service at the defined level, unless enable is set to
'manual' or 'mask' at which point the module will stop ensuring running
or stopped status

##### `enable`

Data type: `Variant[Boolean, Enum['manual', 'mask']]`

Configure the service to automatically start on system start
true, service starts on system start
false, service does not start on system start (puppet will then ensure it
during it's first run to whatever the ensure value is
manual, service will not be managed by puppet other than the enable value
mask, service will not be managed by puppet other than the enable value
