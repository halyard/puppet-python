Puppet::Bindings.newbindings('python::default') do
  bind {
    name         'python'
    to           'function'
    in_multibind 'puppet::module_data'
  }
end
