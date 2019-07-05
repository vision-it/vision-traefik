# Class: vision_traefik::docker
class vision_traefik::docker (

  String $version    = $::vision_traefik::version,
  Array $environment = $::vision_traefik::environment,

  ) {

  $compose = {
    'version' => '3.7',
    'services' => {
      'traefik' => {
        'image'           => "traefik:${version}",
        'volumes'         => [
          '/var/run/docker.sock:/var/run/docker.sock',
          '/vision/data/traefik/:/etc/traefik/',
        ],
        'environment'     => $environment,
        'deploy'          => {
          'placement'     => {
            'constraints' => [ 'node.role == manager' ]
          }
        },
        'ports'           => [
          {
            'target' => 80,
            'published' => 80,
            'protocol' => 'tcp',
            'mode' => 'host',
          },
          {
            'target' => 443,
            'published' => 443,
            'protocol' => 'tcp',
            'mode' => 'host',
          },
        ],
      }
    }
  }

  vision_docker::to_compose { 'traefik':
    compose => $compose,
  }

}
