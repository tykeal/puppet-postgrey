# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include postgrey::service
class postgrey::service (
  String $ensure,
  Variant[Boolean, Enum['manual', 'mask']] $enable,
) {

  # if $service_enable is not a boolean, we don't
  # actually know what the ensure should be
  if (is_bool($enable)) {
    $_ensure = $ensure
  } else {
    $_ensure = undef
  }

  service { 'postgrey':
    ensure     => $_ensure,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => true,
  }
}
