# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include postgrey::install
class postgrey::install (
  Boolean $manage_package,
  String $ensure,
  String $package_name,
) {
  if ($manage_package) {
    package { $package_name:
      ensure => $ensure,
    }
  }
}
