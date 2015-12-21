# Configure ubuntu ppa
#
# === Parameters
#
# [*oldstable*]
#   Install 5.4 (ondrej/php5-oldstable PPA)
#
# [*ppa*]
#   Use a specific PPA, e.g "ondrej/php5-5.6" (without the "ppa:")
#
class php::repo::ubuntu (
  $oldstable = false,
  $ppa       = undef,
) {
  include '::apt'

  validate_bool($oldstable)

  if ($ppa and $oldstable == true) {
    fail('Only one of $oldstable and $ppa can be specified.')
  }

  # Ensure apt_update happens at the appropriate time
  ::Apt::Ppa <| title == "ppa:${release}"
                      or title == 'ppa:ondrej/php5-oldstable'
                      or title == 'ppa:ondrej/php5' |> ->
  Class['::apt::update'] ->
  Anchor['php::begin']

  if ($ppa) {
    ::apt::ppa { "ppa:${ppa}": }
  } elsif ($::lsbdistcodename == 'precise' or $oldstable == true) {
    ::apt::ppa { 'ppa:ondrej/php5-oldstable': }
  } else {
    ::apt::ppa { 'ppa:ondrej/php5': }
  }
}
