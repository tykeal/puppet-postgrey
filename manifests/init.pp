# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include postgrey
class postgrey {
  include postgrey::install
  include postgrey::config
  include postgrey::service

  # Setup class ordering
  Class['postgrey::install']
  -> Class['postgrey::config']
  ~> Class['postgrey::service']
}
