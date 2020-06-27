# @summary Install and configure postgrey
#
# @example
#   include ::postgrey
class postgrey {
  include postgrey::install
  include postgrey::config
  include postgrey::service

  # Setup class ordering
  Class['postgrey::install']
  -> Class['postgrey::config']
  ~> Class['postgrey::service']
}
