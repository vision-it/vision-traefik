require 'spec_helper_acceptance'

describe 'vision_traefik' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        # mock classes
        class vision_docker::swarm () {}
        class vision_gluster::node () {}

        file{ ['/vision', '/vision/data', '/vision/data/swarm']:
          ensure => directory,
        }

        class { 'vision_traefik': }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

  describe file('/vision/data/traefik/traefik.toml') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'managed by Puppet' }
  end

  describe file('/vision/data/traefik/dynamic/redirect.toml') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'managed by Puppet' }
      it { is_expected.to contain 'www-redirect' }
      it { is_expected.to contain 'Host' }
      it { is_expected.to contain 'http.middleware' }
  end

  describe file('/vision/data/traefik/traefik.toml') do
    it { is_expected.to be_file }
    it { is_expected.to contain 'managed by Puppet' }
    it { is_expected.to contain 'checkNewVersion = false' }
    it { is_expected.to contain 'docker' }
    it { is_expected.to contain 'entryPoints' }
    it { is_expected.to contain 'redirections.entrypoint' }
    it { is_expected.to contain 'api' }
    it { is_expected.not_to contain 'certificates' }
    it { is_expected.not_to contain 'certFile' }
    it { is_expected.not_to contain 'keyFile' }
    it { is_expected.to contain 'level = "ERROR"' }
  end

  describe file('/vision/data/swarm/traefik.yaml') do
    it { is_expected.to be_file }
    it { is_expected.to contain 'managed by Puppet' }
    it { is_expected.to contain 'image: traefik:abc123' }
    it { is_expected.to contain '/var/run/docker.sock' }
    it { is_expected.to contain 'node.role == manager' }
    it { is_expected.to contain 'ports' }
    it { is_expected.to contain '80' }
    it { is_expected.to contain '443' }
    it { is_expected.to contain 'example.com' }
    it { is_expected.to contain 'foo=bar' }
  end
end
