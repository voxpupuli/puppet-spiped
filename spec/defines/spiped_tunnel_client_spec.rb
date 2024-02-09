require 'spec_helper'

describe 'spiped::tunnel::client' do
  let(:title) { 'redis' }
  let(:params) do
    {
      source_socket_file: '/var/run/redis.sock',
      target_host: 'redis-host',
      target_port: 1234,
      secret: 'hunter2'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_spiped__tunnel('redis').with(
          source_socket_file: '/var/run/redis.sock',
          target_host: 'redis-host',
          target_port: 1234,
          secret: 'hunter2'
        )
      }

      it {
        is_expected.to contain_file('/etc/spiped/redis.key').with(
          owner: 'root',
          group: 'root',
          mode: '0600',
          show_diff: false,
          content: 'hunter2'
        )
      }

      it {
        is_expected.to contain_file('/lib/systemd/system/spiped-redis.service').
          with_ensure('absent').
          that_comes_before('Systemd::Unit_file[spiped-redis.service]')
      }

      describe 'unit file' do
        let(:content) { catalogue.resource('systemd::unit_file', 'spiped-redis.service').send(:parameters)[:content] }

        it { is_expected.to contain_systemd__unit_file('spiped-redis.service') }

        it 'Description' do
          expect(content).to include('Description=spiped tunnel (redis)')
        end

        it 'ExecStart' do
          expect(content).to include('ExecStart=/usr/bin/spiped -e -D -g -F -k \'/etc/spiped/redis.key\' -s \'/var/run/redis.sock\' -t \'redis-host:1234\'')
        end
      end

      it {
        is_expected.to contain_service('spiped-redis').with(
          ensure: 'running',
          enable: true
        ).that_requires('Package[spiped]').that_subscribes_to(['Systemd::Unit_file[spiped-redis.service]', 'File[/etc/spiped/redis.key]'])
      }
    end
  end
end
