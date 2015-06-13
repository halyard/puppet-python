require 'spec_helper'

describe 'python' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "python class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('python::params') }
          it { is_expected.to contain_class('python::install').that_comes_before('python::config') }
          it { is_expected.to contain_class('python::config') }
          it { is_expected.to contain_class('python::service').that_subscribes_to('python::config') }

          it { is_expected.to contain_service('python') }
          it { is_expected.to contain_package('python').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'python class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('python') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
