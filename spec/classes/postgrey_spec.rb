# frozen_string_literal: true

require 'spec_helper'

describe 'postgrey' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('postgrey::install') }
      it { is_expected.to contain_package('postgrey') }
      it { is_expected.to contain_class('postgrey::config') }
      it { is_expected.to contain_class('postgrey::service') }
    end
  end
end
