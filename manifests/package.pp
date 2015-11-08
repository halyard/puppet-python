# Install a Python package for a given version of Python
#
# Usage:
#
#   python::package { 'virtualenv==1.11.2 for 2.7.6':
#     package => 'virtualenv'
#     python  => '2.7.6',
#     version => '==1.11.2',
#   }
#

define python::package(
    $package,
    $python,
    $ensure = 'present',
    $version = '>= 0',
) {
  require python

  $pyenv_versions = any2array($python)

  $pyenv_versions.each |$pyenv_version| {
    pyenv_package { "${name} for ${pyenv_version}":
      ensure        => $ensure,
      package       => $package,
      version       => $version,
      pyenv_version => $pyenv_version,
      pyenv_root    => $python::pyenv::prefix,
      provider      => pip,
    }
  }
}
