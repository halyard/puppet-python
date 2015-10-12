Puppet::Functions.create_function(:'python::data') do
  def data
    user = closure_scope.lookupvar('::boxen_user')
    prefix = closure_scope.lookupvar('::boxen::config::home')
    installdir = closure_scope.lookupvar('::homebrew::config::installdir')
    darwin_build_opts = {
      'CFLAGS' => "-I#{installdir}/include -I#{installdir}/opt/openssl/include -march=core2 -O3",
      'LDFLAGS' => "-L#{installdir}/lib -L#{installdir}/opt/openssl/lib",
      'PYTHON_CONFIGURE_OPTS' => "--with-readline-dir=#{installdir}/opt/readline"
    }
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
        'Darwin' => darwin_build_opts
      }
    }
  end
end
