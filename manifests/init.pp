# Class: vision_traefik

class vision_traefik (

  Array $environment,
  String $version,
  Optional[String] $x509_certificate = undef,
  Optional[String] $x509_key = undef,

) {

  file { '/vision/data/traefik':
    ensure => directory,
  }

  file { '/vision/data/traefik/traefik.toml':
    ensure  => present,
    content => template('vision_traefik/traefik.toml.erb'),
    require => File['/vision/data/traefik'],
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
  
  firewall { '100 allow HTTP traffic':
    dport  => 80,
    proto  => tcp,
    action => accept,
  }
  
  firewall { '100 allow HTTPS traffic':
    dport  => 443,
    proto  => tcp,
    action => accept,
  }

  contain ::vision_traefik::docker
}
