# Class: vision_traefik

class vision_traefik (

  Array $environment,
  String $version,
  String $log_level,
  String $whitelist, # For Traefik UI
  Boolean $access_log,
  Optional[String] $x509_certificate = undef,
  Optional[String] $x509_key = undef,

) {

  file { ['/vision/data/traefik',
          '/vision/data/traefik/logs',
          '/vision/data/traefik/dynamic']:
    ensure => directory,
  }

  file { 'traefik config':
    ensure  => present,
    path    => '/vision/data/traefik/traefik.toml',
    content => template('vision_traefik/traefik.toml.erb'),
    require => File['/vision/data/traefik'],
  }

  file { 'redirect config':
    ensure  => present,
    path    => '/vision/data/traefik/dynamic/redirect.toml',
    content => template('vision_traefik/redirect.toml.erb'),
    require => File['/vision/data/traefik/dynamic'],
  }

  exec { 'reload traefik':
    command     => '/usr/bin/docker service update --force vision_traefik',
    subscribe   => File['traefik config'],
    refreshonly => true,
  }

  if $x509_certificate != undef {
    file { '/vision/data/traefik/cert.pem':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => $x509_certificate,
      require => File['/vision/data/traefik'],
    }
  }

  if $x509_key != undef {
    file { '/vision/data/traefik/key.pem':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => $x509_key,
      require => File['/vision/data/traefik'],
    }
  }

  contain ::vision_traefik::docker
}
