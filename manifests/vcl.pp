# Define a VCL from a Puppet template
# and load the VCL
#
# If the VCL fails to parse, the exec will fail
# and Varnish will continue to run with the old config
define varnish::vcl (
  $content = undef,
  $source  = undef,
  $file    = $name
) {

  if $content == undef and $source == undef {
    fail("You need exactly one non-empty content or source parameter")
  }

  if $content != undef and $source != undef {
    fail("You need exactly one non-empty content or source parameter")
  }

  include varnish
  include varnish::params

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['varnish::install'],
    notify  => Exec['vcl_reload'],
  }

  if $content {
    file { $file:
      content => $content
    }
  }

  if $source {
    file { $file:
      source => $source
    }
  }
}
