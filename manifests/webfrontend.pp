class ganglia::webfrontend inherits ganglia::server {
  package { ['apache2', 'apache2.2-common']:
    ensure => installed,
  }

  service { 'apache2':
    ensure  => running,
    enable  => true,
    require => Package['apache2'],
  }

  package { 'libapache2-mod-wsgi':
    ensure => installed,
  }

  file { '/etc/apache2/services':
    ensure  => directory,
    require => Package['apache2'],
  }
  
  package { 'libapache2-mod-php5':
    ensure => installed,
  }

  exec { '/usr/sbin/a2enmod php5':
    creates => '/etc/apache2/mods-enabled/php5.load',
    require => Package['apache2.2-common'],
    notify  => Service['apache2'],
  }

  package { 'ganglia-webfrontend':
    ensure => installed;
  }

  file { '/etc/apache2/conf.d/ganglia.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => "Alias /ganglia /usr/share/ganglia-webfrontend/\n",
  } 
}
