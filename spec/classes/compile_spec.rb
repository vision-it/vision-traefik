require 'spec_helper'
require 'hiera'

describe 'vision_traefik' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let :pre_condition do
        [
          'class vision_docker::swarm () {}',
          'class vision_gluster::node () {}',
        ]
      end

      # Default check to see if manifest compiles
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'contains' do
        it { is_expected.to contain_class('vision_traefik::docker') }
      end
    end
  end
end
