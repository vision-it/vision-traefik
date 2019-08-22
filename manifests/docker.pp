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
          },
          'labels'        => [
            'traefik.port=8080',
            'traefik.frontend.rule=PathPrefixStrip:/traefik',
            'traefik.enable=true',
            'traefik.frontend.whiteList.sourceRange=10.54.0.0/16,10.55.63.0/24',
            'traefik.docker.network=vision_default',
           ],
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
