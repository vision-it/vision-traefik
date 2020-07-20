# Class: vision_traefik::docker
class vision_traefik::docker (

  String $version    = $::vision_traefik::version,
  String $whitelist  = $::vision_traefik::whitelist,
  Array $environment = $::vision_traefik::environment,
  String $traefik_rule = $::vision_traefik::traefik_rule,

) {

  $compose = {
    'version'           => '3.7',
    'services'          => {
      'proxy' => {
        'image'           => "tecnativa/docker-socket-proxy",
        'volumes'         => [
          '/var/run/docker.sock:/var/run/docker.sock:ro',
        ],
        'environment'     => [
          'CONTAINER=1',
          'TASKS=1',
          'SWARM=1',
          'NETWORKS=1',
          'SERVICES=1',
        ],
        'deploy'          => {
          'mode'          => 'global',
        }
      },
      'traefik'         => {
        'image'           => "traefik:${version}",
        'volumes'       => [
          '/vision/data/traefik/:/etc/traefik/',
        ],
        'environment'   => $environment,
        'deploy'        => {
          # deploy Traefik on each manager node, so port 80/443 is available everywhere
          'mode'          => 'global',
          'placement'     => {
            'constraints' => [ 'node.role == manager' ]
          },
          'labels'      => [
            'traefik.enable=true',
            'traefik.http.services.traefik.loadbalancer.server.port=8080',
            "traefik.http.routers.traefik.rule=Host(`${traefik_rule}`) && PathPrefix(`/traefik`) || Host(`${traefik_rule}`) && PathPrefix(`/api`)",
            'traefik.http.routers.traefik.service=api@internal',
            'traefik.http.routers.traefik.entrypoints=https',
            'traefik.http.routers.traefik.tls=true',
            "traefik.http.routers.prometheus.rule=Host(`${traefik_rule}`) && PathPrefix(`/metrics`)",
            'traefik.http.routers.prometheus.service=prometheus@internal',
            'traefik.http.routers.prometheus.entrypoints=https',
            'traefik.http.routers.prometheus.tls=true',
            'traefik.http.routers.prometheus.middlewares=whitelist-traefik@docker',
            'traefik.http.routers.traefik.middlewares=strip-traefik@docker,whitelist-traefik@docker',
            'traefik.http.middlewares.strip-traefik.stripprefix.prefixes=/traefik',
            "traefik.http.middlewares.whitelist-traefik.ipwhitelist.sourcerange=${whitelist}",
          ],
        },
        'ports'         => [
          {
            'target'    => 80,
            'published' => 80,
            'protocol'  => 'tcp',
            'mode'      => 'host',
          },
          {
            'target'    => 443,
            'published' => 443,
            'protocol'  => 'tcp',
            'mode'      => 'host',
          },
        ],
      }
    }
  }

  vision_docker::to_compose { 'traefik':
    compose => $compose,
  }

}
