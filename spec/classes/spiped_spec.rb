require 'spec_helper'

describe 'spiped' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('spiped') }
        it { is_expected.to contain_package('spiped').only_with_ensure('present') }
        it { is_expected.to contain_file('/etc/spiped').only_with_ensure('directory') }
      end

      context 'with package_source' do
        case facts[:osfamily]
        when 'Debian'
          let(:params) { { 'package_source' => '/path/to/spiped.deb' } }

          it {
            is_expected.to contain_package('spiped').
              with(
                ensure: 'present',
                provider: 'dpkg',
                source: '/path/to/spiped.deb'
              )
          }
        else
          let(:params) { { 'package_source' => '/path/to/spiped.rpm' } }

          it {
            is_expected.to contain_package('spiped').
              with(
                ensure: 'present',
                provider: 'rpm',
                source: '/path/to/spiped.rpm'
              )
          }
        end
      end
    end
  end
end
