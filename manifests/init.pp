# Class: vision_traefik

class vision_traefik (

  Array $environment,
  String $version,

) {

  file { '/vision/data/traefik':
    ensure => directory,
  }

  file { '/vision/data/traefik/traefik.toml':
    ensure  => present,
    content => template('vision_traefik/traefik.toml.erb'),
    require => File['/vision/data/traefik'],
  }

  contain ::vision_traefik::docker
}
