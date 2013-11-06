class ganglia::server($collected_clusters, $grid_name) inherits ganglia {
  package { 'gmetad':
    ensure => installed,
  }

  file { '/etc/ganglia/gmetad.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0640',
    content => template("ganglia/gmetad.conf.erb"),
    require => Package['gmetad'],
    notify  => Service['gmetad'],
  }

  file { '/var/lib/ganglia/rrds':
    ensure  => directory,
    owner   => ganglia,
    group   => ganglia,
    mode    => '0755',
    require => Package['gmetad'],
    notify  => Service['gmetad'],
  }

  service { 'gmetad':
    enable    => true,
    ensure    => running,
    hasstatus => false,
    pattern   => '/usr/sbin/gmetad',
    require   => Package['gmetad'],
  }
}
