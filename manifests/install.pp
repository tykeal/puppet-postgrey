# @summary Installs postgrey
#
# Installs postgrey using the available package
#
# @param manage_package
#   If true, will ensure the postgrey package (default: true)
# @param ensure
#   If true, will ensure the package as stated (default: present)
#   NOTE: the default makes sure it is installed, but will not upgrade unless
#   changed to latest!
# @param package_name
#   The name of the package to install (default: postgrey)
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
