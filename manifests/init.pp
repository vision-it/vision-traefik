# Class: vision_traefik

class vision_traefik (

  Array $environment,
  String $version,

) {

  file { '/vision/data/traefik':
    ensure => present,
  }

  file { '/vision/data/traefik/traefik.toml':
    ensure  => present,
    content => template('vision_traefik/traefik.toml.erb')
  }

  contain ::vision_traefik::docker
}
