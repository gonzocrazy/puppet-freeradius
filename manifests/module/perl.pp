# == Define freeradius::module::perl
#
# Create the perl module configuration for FreeRADIUS
#
define freeradius::module::perl (
  $ensure                                               = file,
  String $moddir                                        = "${fr_moduleconfigpath}/perl",
  Optional[String] $key                                 = undef,
  Optional[String] $perl_filename                       = undef,
  Optional[String] $path                                = undef,
  Optional[String] $content                             = undef,
  Optional[Hash[String, String]] $function_names        = undef,
  Optional[Hash[String, String]] $split_accouting_names = undef,
) {
  $fr_moduleconfigpath = $::freeradius::params::fr_moduleconfigpath
  $fr_group            = $::freeradius::params::fr_group
  $fr_service          = $::freeradius::params::fr_service
  $source              = "${path}/${perl_filename}"
  freeradius::module {'perl':
    ensure  => $ensure,
    content => template('freeradius/perl.erb'),
  }

  file { "${fr_moduleconfigpath}/perl/${perl_filename}":
    ensure  => file,
    owner   => 'root',
    group   => $fr_group,
    mode    => '0640',
    source  => $source,
    content => $content,
    require => Freeradius::Module['perl'],
    notify  => Service[$fr_service],
  }
}
