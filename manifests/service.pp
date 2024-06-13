# @summary Manages the postgrey service
#
# Configures the postgrey service as defined
#
# @param ensure
#   Ensures the service at the defined level, unless enable is set to
#   'manual' or 'mask' at which point the module will stop ensuring running
#   or stopped status
# @param enable
#   Configure the service to automatically start on system start
#   true, service starts on system start
#   false, service does not start on system start (puppet will then ensure it
#   during it's first run to whatever the ensure value is
#   manual, service will not be managed by puppet other than the enable value
#   mask, service will not be managed by puppet other than the enable value
class postgrey::service (
  String $ensure,
  Variant[Boolean, Enum['manual', 'mask']] $enable,
) {
  # if $service_enable is not a boolean, we don't
  # actually know what the ensure should be
  if $enable.is_a(Boolean) {
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
