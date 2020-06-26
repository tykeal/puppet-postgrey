# frozen_string_literal: true

require 'spec_helper'

describe 'postgrey::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_package('postgrey') }

      context 'with manage_package => false' do
        let(:params) do
          {
            manage_package: false,
          }
        end

        it { is_expected.not_to contain_package('postgrey') }
      end

      context 'with package_name => foo' do
        let(:params) do
          {
            package_name: 'foo',
          }
        end

        it { is_expected.to contain_package('foo') }
      end
    end
  end
end
