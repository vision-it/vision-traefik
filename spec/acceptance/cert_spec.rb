require 'spec_helper_acceptance'

describe 'vision_traefik' do
  context 'with certificates' do
    it 'run idempotently' do
      pp = <<-FILE
        # mock classes
        class vision_docker::swarm () {}
        class vision_gluster::node () {}

        file{ ['/vision', '/vision/data', '/vision/data/swarm']:
          ensure => directory,
        }

        class { 'vision_traefik':
          x509_certificate => '---snake oil certificate---',
          x509_key => '---snake oil key---',
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
      it { is_expected.to contain '[[entryPoints.https.tls.certificates]]' }
      it { is_expected.to contain 'certFile = "/etc/traefik/cert.pem"' }
      it { is_expected.to contain 'keyFile = "/etc/traefik/key.pem"' }
    end

    describe file('/vision/data/traefik/cert.pem') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'snake oil certificate' }
      it { is_expected.to be_grouped_into('root') }
      it { is_expected.to be_owned_by('root') }
      it { is_expected.to be_mode(640) }
    end

    describe file('/vision/data/traefik/key.pem') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'snake oil key' }
      it { is_expected.to be_grouped_into('root') }
      it { is_expected.to be_owned_by('root') }
      it { is_expected.to be_mode(640) }
    end
end
