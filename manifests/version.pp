# Install a Python version via pyenv
#
# Usage:
#
#   python::version { '2.7.3': }
#

define python::version(
  $ensure  = 'installed',
  $env     = {},
  $version = $name,
) {
  require python

  $alias_hash = $python::version_alias
  $dest = "/opt/python/${version}"

  if has_key($alias_hash, $version) {
    $to = $alias_hash[$version]

    python::alias { $version:
      ensure => $ensure,
      to     => $to,
    }
  } elsif $ensure == 'absent' {
    file { $dest:
      ensure => absent,
      force  => true,
    }
  } else {
    case $version {
      /jython/: { require java }
      default: { }
    }

    $pyenv = $python::pyenv::prefix

    $default_env = {
      'CC'         => '/usr/bin/cc',
      'PYENV_ROOT' => $pyenv,
    }

    if $::operatingsystem == 'Darwin' {
      include homebrew::config
      include boxen::config
      ensure_resource('package', 'readline')
    }

    $env_data = $python::version_env

    if has_key($env_data, 'global') {
      $global_env = $env_data['global']
    } else {
      $global_env = {}
    }

    if has_key($env_data, $::operatingsystem) {
      $os_env = $env_data[$::operatingsystem]
    } else {
      $os_env = {}
    }

    if has_key($env_data, $version) {
      $version_env = $env_data[$version]
    } else {
      $version_env = {}
    }

    $_env = merge(
      merge(
        merge(
          merge($default_env, $os_env),
          $version_env
        ),
        $global_env,
      ),
      $env
    )

    if has_key($_env, 'CC') and $_env['CC'] =~ /gcc/ {
      require gcc
    }

    exec { "python-install-${version}":
      command  => "${pyenv}/bin/pyenv install --skip-existing ${version}",
      cwd      => "${pyenv}/versions",
      provider => 'shell',
      timeout  => 0,
      creates  => $dest,
      user     => $python::pyenv::user,
      require  => Package['readline'],
    }

    Exec["python-install-${version}"] {
      environment +> sort(join_keys_to_values($_env, '='))
    }
  }
}
