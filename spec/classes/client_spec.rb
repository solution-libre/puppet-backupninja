require 'spec_helper'

describe 'backupninja::client' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('backupninja::client') }
      end
    end
  end
end
