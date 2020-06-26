# frozen_string_literal: true

require 'spec_helper'

describe 'postgrey::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_service('postgrey').with(
          ensure: 'running',
          enable: true,
        )
      }

      context 'with ensure => stopped' do
        let(:params) do
          {
            ensure: 'stopped',
          }
        end

        it {
          is_expected.to contain_service('postgrey').with(
            ensure: 'stopped',
          )
        }
      end

      context 'with enable => manual' do
        let(:params) do
          {
            enable: 'manual',
          }
        end

        it {
          is_expected.to contain_service('postgrey').with(
            ensure: nil,
            enable: 'manual',
          )
        }
      end
    end
  end
end
