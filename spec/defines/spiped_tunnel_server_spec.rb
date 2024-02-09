require 'spec_helper'

describe 'spiped::tunnel::server' do
  let(:title) { 'redis' }
  let(:params) do
    {
      source_host: '0.0.0.0',
      source_port: 1234,
      target_socket_file: '/var/run/redis.sock',
      secret: 'hunter2'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it {
        is_expected.to contain_spiped__tunnel('redis').with(
          type: 'server',
          source_host: '0.0.0.0',
          source_port: 1234,
          target_socket_file: '/var/run/redis.sock',
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
          expect(content).to include('ExecStart=/usr/bin/spiped -d -g -F -k \'/etc/spiped/redis.key\' -s \'[0.0.0.0]:1234\' -t \'/var/run/redis.sock\'')
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

  describe 'conflicting parameters' do
    describe 'source parameters' do
      context 'source_socket_file and source_host' do
        let(:params) do
          {
            source_socket_file: '/path/to/socket',
            source_host: '0.0.0.0',
            target_socket_file: '/var/run/redis.sock',
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{`source_host` must not be specified when using `source_socket_file`}) }
      end

      context 'source_socket_file and source_port' do
        let(:params) do
          {
            source_socket_file: '/path/to/socket',
            source_port: 1234,
            target_socket_file: '/var/run/redis.sock',
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{`source_port` must not be specified when using `source_socket_file`}) }
      end

      context 'missing source_host' do
        let(:params) do
          {
            source_port: 1234,
            target_socket_file: '/var/run/redis.sock',
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{either `source_socket_file` or `source_host` and `source_port must be specified}) }
      end

      context 'missing source_port' do
        let(:params) do
          {
            source_host: '0.0.0.0',
            target_socket_file: '/var/run/redis.sock',
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{either `source_socket_file` or `source_host` and `source_port must be specified}) }
      end
    end

    describe 'target parameters' do
      context 'target_socket_file and target_host' do
        let(:params) do
          {
            source_socket_file: '/path/to/socket',
            target_socket_file: '/var/run/redis.sock',
            target_host: 'redis-host',
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{`target_host` must not be specified when using `target_socket_file`}) }
      end

      context 'target_socket_file and target_port' do
        let(:params) do
          {
            source_socket_file: '/path/to/socket',
            target_socket_file: '/var/run/redis.sock',
            target_port: 1234,
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{`target_port` must not be specified when using `target_socket_file`}) }
      end

      context 'missing target_host' do
        let(:params) do
          {
            source_socket_file: '/path/to/socket',
            target_port: 1234,
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{either `target_socket_file` or `target_host` and `target_port must be specified}) }
      end

      context 'missing target_port' do
        let(:params) do
          {
            source_socket_file: '/path/to/socket',
            target_host: 'redis-host',
            secret: 'hunter2'
          }
        end

        it { is_expected.to compile.and_raise_error(%r{either `target_socket_file` or `target_host` and `target_port must be specified}) }
      end
    end
  end
end
