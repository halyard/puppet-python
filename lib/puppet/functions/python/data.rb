Puppet::Functions.create_function(:'python::data') do
  def data
    user = closure_scope.lookupvar('::boxen_user')
    prefix = closure_scope.lookupvar('::boxen::config::home')
    installdir = closure_scope.lookupvar('::homebrew::config::installdir')
    {
      'python::user' => user,
      'python::prefix' => prefix,
      'python::pyenv::user' => user,
      'python::pyenv::prefix' => "#{prefix}/pyenv",
      'python::pyenv::ensure' => 'v20150913',
      'python::version_alias' => {
       '2' => '2.7.10',
       '2.6' => '2.6.9',
       '2.7' => '2.7.10',
       '3' => '3.5.0',
       '3.4' => '3.4.3',
       '3.5' => '3.5.0'
      },
      'python::version_env' => {
      }
    }
  end
end
