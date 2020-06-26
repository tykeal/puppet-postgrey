# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include postgrey::config
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

#  file { '/etc/sysconfig/postgrey':
#    ensure  => file,
#    owner   => 'root',
#    group   => 'root',
#    mode    => '0644',
#    content => epp("${module_name}/sysconfig.epp",
#      {
#        options => $options,
#      })
#  }
}
