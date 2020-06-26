# frozen_string_literal: true

require 'spec_helper'

describe 'postgrey::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_file('/etc/postfix/postgrey_whitelist_clients.local').with(
          'content' => '',
        )
      }
      it {
        is_expected.to contain_file('/etc/postfix/postgrey_whitelist_recipients').with(
          'content' => '',
        )
      }
      it {
        is_expected.to contain_file('/etc/sysconfig/postgrey').with(
          'content' => '# DO NOT EDIT: File managed by puppet
POSTGREY_USER="--user=postgrey"
POSTGREY_GROUP="--group=postgrey"
POSTGREY_DELAY="--delay=300"
POSTGREY_PID="--pidfile=/var/run/postgrey.pid"
POSTGREY_TYPE="--unix=/var/spool/postfix/postgrey/socket"
POSTGREY_OPTS="--privacy --quiet "
',
        )
      }

      context 'with bad whitelist' do
        let(:params) do
          {
            whitelist: ['foo@bar.com'],
          }
        end

        it { is_expected.not_to compile }
      end
      context 'with good whitelist' do
        let(:params) do
          {
            whitelist:
            [
              '10.0.0.1',
              'localhost',
              'foo.bar',
            ],
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file('/etc/postfix/postgrey_whitelist_clients.local').with(
            'content' => "10.0.0.1\nlocalhost\nfoo.bar\n",
          )
        }
      end

      context 'with bad whitelist_recipients' do
        let(:params) do
          {
            whitelist_recipients: ['foo'],
          }
        end

        it { is_expected.not_to compile }
      end
      context 'with good whitelist_recipients' do
        let(:params) do
          {
            whitelist_recipients: ['foo@', 'bar@'],
          }
        end

        it { is_expected.to compile }
        it {
          is_expected.to contain_file('/etc/postfix/postgrey_whitelist_recipients').with(
            'content' => "foo@\nbar@\n",
          )
        }
      end

      context "with both 'unix' and 'inet' defined" do
        let(:params) do
          {
            type: {
              'inet' => { 'port'   => 55_555 },
              'unix' => { 'socket' => '/foo/bar' },
            },
          }
        end

        it { is_expected.not_to compile }
      end
    end
  end
end
