require 'spec_helper_acceptance'

describe 'vision_traefik' do
  context 'with access_logs' do
    it 'run idempotently' do
      pp = <<-FILE
        # mock classes
        class vision_docker::swarm () {}
        class vision_gluster::node () {}

        file{ ['/vision', '/vision/data', '/vision/data/swarm']:
          ensure => directory,
        }

        file{ '/usr/bin/docker':
          ensure => present,
        }

        class { 'vision_traefik':
          access_log => true,
        }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end

    describe file('/vision/data/traefik/traefik.toml') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'managed by Puppet' }
      it { is_expected.to contain 'entryPoints' }
      it { is_expected.to contain 'level =' }
      it { is_expected.to contain '[accessLog]' }
      it { is_expected.to contain 'filePath = "/etc/traefik/logs/access.log"' }
      it { is_expected.to contain '[accessLog.fields.headers.names]' }
    end

    describe file('/vision/data/traefik/logs') do
      it { is_expected.to be_directory }
    end
end
