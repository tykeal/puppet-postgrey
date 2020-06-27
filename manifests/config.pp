# @summary Configure postgrey
#
# Builds postgrey configuration files from hiera data. Any parameters that
# default to undef are optional and will cause postgrey to use the builtin
# defaults for those settings if they exist.
#
# @param exim
#   If true, sets the --exim option (default: false)
# @param delay
#   Sets the --delay option (default: 300)
# @param group
#   Sets the --group option (default: postgrey)
# @param lookup_by_host
#   If true, sets the lookup-by-host option (default: false)
# @param lookup_by_subnet
#   If true, sets the lookup-by-subnet option (default: false)
# @param pidfile
#   The absolute filepath to where the pidfile should live.
#   (default: /var/run/postgrey.pid)
# @param privacy
#   If true, sets the --privacy option (default: true)
# @param quiet
#   If true, sets the --quiet option (default: true)
# @param type
#   Enables either inet or unix listening type
#   * inet requires a port defined and an optional host
#   * unix requires a socket path (default: /var/spool/postfix/postgrey/socket)
#     and an optional socket mode
#   * Only listening option may be set, the default is to use 'unix'
# @param user
#   Sets the --user option (default: postgrey)
# @param whitelist
#   An array of host type entries for the local whitelist (allowlist). This is
#   used to create the /etc/postfix/postgrey_whitelist_clients.local file
#   (default: [])
# @param whitelist_recipients
#   An array of left side email address (user@) to configure the local
#   allowlist of recipients. This sets the
#   /etc/postfix/postgrey_whitelist_recipients file (default: [])
# @param auto_whitelist_clients
#   Configures the --auto-whitelist-clients option (default: undef)
# @param greylist_action
#   Configures the --greylist-action option (default: undef)
# @param hostname
#   Configures the --hostname option (default: undef, postgrey will
#   automatically use the fqdn if this is not set)
# @param ipv4cidr
#   Configures the --ipv4cidr option (default: undef)
# @param ipv6cidr
#   Configures the --ipv6cidr option (default: undef)
# @param listen_queue_size
#   Configures the --listen-queue-size option (default: undef)
# @param max_age
#   Configures the --max-age option (default: undef)
# @param retry_window
#   Configures the --retry-window option (default: undef)
# @param syslog_facility
#   Configures the --syslog-facility option (default: undef)
# @param x_greylist_header
#   Configures the --x-greylist-header option (default: undef)
class postgrey::config (
  # Required
  Boolean $exim,
  Integer[0] $delay,
  String[1] $group,
  Boolean $lookup_by_host,
  Boolean $lookup_by_subnet,
  Stdlib::AbsolutePath $pidfile,
  Boolean $privacy,
  Boolean $quiet,
  Struct[{
      inet => Optional[Struct[{
                port => Stdlib::Port,
                host => Optional[Stdlib::Host],
              }]],
      unix => Optional[Struct[{
                socket  => Stdlib::AbsolutePath,
                mode    => Optional[Stdlib::Filemode],
              }]],
  }] $type,
  String[1] $user,
  Array[Stdlib::Host] $whitelist,
  Array[Pattern[/\S+@/]] $whitelist_recipients,

  # Optional
  Optional[Integer[0]] $auto_whitelist_clients = undef,
  Optional[String[1]] $greylist_action = undef,
  Optional[Stdlib::Fqdn] $hostname = undef,
  Optional[Integer[0,32]] $ipv4cidr = undef,
  Optional[Integer[4,128]] $ipv6cidr = undef,
  Optional[Integer[1]] $listen_queue_size = undef,
  Optional[Integer[1]] $max_age = undef,
  Optional[Variant[Integer[1],Regexp[/\d+h/]]] $retry_window = undef,
  Optional[String[1]] $syslog_facility = undef,
  Optional[String[1]] $x_greylist_header = undef,
) {
  file { '/etc/postfix/postgrey_whitelist_clients.local':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/postgrey_whitelist_clients.local.epp",
      {
        'whitelist' => $whitelist,
      })
  }

  file { '/etc/postfix/postgrey_whitelist_recipients':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/postgrey_whitelist_recipients.epp",
      {
        'whitelist' => $whitelist_recipients,
      })
  }

  if ('unix' in keys($type) and 'inet' in keys($type)) {
    fail("'unix' and 'inet' options are both defind for type. Only one may be set")
  }

  if !('unix' in keys($type)) and !('inet' in keys($type)) {
    fail("Must set either 'unix' or 'inet' for type")
  }

  file {'/etc/sysconfig/postgrey':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/sysconfig.epp",
      {
        bools                => {
          exim             => $exim,
          lookup-by-host   => $lookup_by_host,
          lookup-by-subnet => $lookup_by_subnet,
          privacy          => $privacy,
          quiet            => $quiet,
        },
        delay                => $delay,
        group                => $group,
        pidfile              => $pidfile,
        type                 => $type,
        user                 => $user,
        whitelist            => $whitelist,
        whitelist_recipients => $whitelist_recipients,
        options              => {
          auto-whitelist-clients => $auto_whitelist_clients,
          greylist-action        => $greylist_action,
          hostname               => $hostname,
          ipv4cidr               => $ipv4cidr,
          ipv6cidr               => $ipv6cidr,
          listen-queue-size      => $listen_queue_size,
          max-age                => $max_age,
          retry-window           => $retry_window,
          syslog-facility        => $syslog_facility,
          x-greylist-header      => $x_greylist_header,
        },
      }
    )
  }
}
