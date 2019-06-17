require 'spec_helper_acceptance'

describe 'spiped' do
  server_ip = hosts_as('spipedserver')[0].get_ip

  describe 'spiped::tunnel::server defined type' do
    it 'setups spiped server idempotently' do
      pp = %(
      spiped::tunnel::server { 'redis':
        source_host => '0.0.0.0',
        source_port => 16379,
        target_host => '127.0.0.1',
        target_port => 6379,
        secret => 'hunter2',
      }
      )
      apply_manifest_on(hosts_as('spipedserver'), pp, catch_failures: true)
      apply_manifest_on(hosts_as('spipedserver'), pp, catch_changes: true)
    end
  end

  describe 'spiped::tunnel::client defined type' do
    it 'setups spiped client idempotently' do
      pp = %(
      spiped::tunnel::client { 'redis':
        source_host => '127.0.0.1',
        source_port => 1234,
        target_host => '#{server_ip}',
        target_port => 16379,
        secret => 'hunter2',
      }
      )
      apply_manifest_on(hosts_as('spipedclient'), pp, catch_failures: true)
      apply_manifest_on(hosts_as('spipedclient'), pp, catch_changes: true)
    end
  end

  describe service('spiped-redis') do
    it { is_expected.to be_running }
  end

  describe 'redis over tunnel' do
    if fact('hostname') == 'spipedserver'
      describe command('sed -i "s/^bind.*/bind 127.0.0.1/g" /etc/redis/redis.conf') do
        its(:exit_status) { is_expected.to eq 0 }
      end
      describe command('systemctl start redis') do
        its(:exit_status) { is_expected.to eq 0 }
      end
      describe port(6379) do
        it { is_expected.to be_listening }
      end
      describe port(16_379) do
        it { is_expected.to be_listening }
      end
    else
      describe command('redis_cli -h 127.0.0.1 -p 1234') do
        its(:stdout) { is_expected.to match %r{PONG} }
      end
    end
  end
end
