require 'spec_helper'

describe 'python' do
  let(:facts) { default_test_facts }
  let(:root) { "/test/boxen/pyenv" }
  let(:versions) { "#{root}/versions" }

  it do
    should include_class("python::rehash")

    should contain_repository(root).with({
      :ensure => 'v0.2.0',
      :source => "yyuu/pyenv",
      :user   => "testuser",
    })

    should contain_file(versions).with_ensure('directory')

    should contain_file("/test/boxen/env.d/pyenv.sh").
      with_source("puppet:///modules/python/pyenv.sh")
  end
end
