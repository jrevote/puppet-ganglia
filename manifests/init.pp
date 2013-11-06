# == Class: ganglia
#
# Full description of class ganglia here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { ganglia:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class ganglia($cluster_name, $upstreams) {

  package { 'ganglia-monitor':
    ensure => installed,
  }

  service { 'ganglia-monitor':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    pattern   => '/usr/sbin/gmond',
    require   => Package['ganglia-monitor'],
    subscribe => File['/etc/ganglia/gmond.conf'],
  }

  file { '/etc/ganglia/gmond.conf':
    ensure  => present,
    owner   => root,
    group   => ganglia,
    mode    => '0640',
    require => Package['ganglia-monitor'],
    content => template('ganglia/gmond.conf.erb');
  }
  
  file { '/etc/ganglia/conf.d':
    ensure  => directory,
    owner   => root,
    group   => ganglia,
    mode    => '0750',
    require => Package['ganglia-monitor'],
  }
}
