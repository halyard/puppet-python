**Deprecation Notice:** I'm in the process of revamping my puppet work, this repo is currently not up to date.

python
==============

[![Puppet Forge](https://img.shields.io/puppetforge/v/halyard/python.svg)](https://forge.puppetlabs.com/halyard/python)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)
[![Build Status](https://img.shields.io/travis/com/halyard/puppet-python.svg)](https://travis-ci.com/halyard/puppet-python)

Install Python versions using [pyenv](https://github.com/yyuu/pyenv). Module based off of [puppet-ruby](https://github.com/boxen/puppet-ruby) and [puppet-nodejs](https://github.com/boxen/puppet-nodejs).

This is a fork from [Matthew Loberg's puppet-python](https://github.com/mloberg/puppet-python), tweaked for my environment and Puppet 4 compat.

## Changes from upstream

* Adjusted to use CircleCI
* Adjusted to support Puppet 4 module data bindings
* Added support for multiple global python versions
* Added support to python::package for an array of versions
* Allow skipping pyenv init on shell creation using SKIP_PYENV_INIT environment variable

## Usage

```puppet
# Install Python versions
python::version { '2.7.10': }
python::version { '3.5.0': }

# Set the global version of Python
class { 'python::global':
  version => '2.7.7'
}

# ensure a certain python version is used in a dir
python::local { '/path/to/some/project':
  version => '3.4.1'
}

# Install the latest version of virtualenv
$version = '3.4.1'
python::package { "virtualenv for ${version}":
  package => 'virtualenv',
  python  => $version,
}
# Install Django 1.6.x
python::package { "django for 2.7.7":
  package => 'django',
  python  => '2.7.7',
  version => '>=1.6,<1.7',
}

# Installing a pyenv plugin
python::plugin { 'pyenv-virtualenvwrapper':
  ensure => 'v20140122',
  source => 'yyuu/pyenv-virtualenvwrapper',
}

# Running a package script
# pyenv-installed gems cannot be run in the boxen installation environment which uses the system
# python. The environment must be cleared (env -i) so an installed python (and packages) can be used in a new shell.
exec { "env -i bash -c 'source /opt/boxen/env.sh && PYENV_VERSION=${version} virtualenv venv'":
  provider => 'shell',
  cwd => "~/src/project",
  require => Python::Package["virtualenv for ${version}"],
}
```

## Required Puppet Modules

* `boxen >= 3.2.0`
* `repository >= 2.1`
* `gcc`
* `stdlib`
* `java` (jython)

## License

puppet-python is released under the MIT License. See the bundled LICENSE file for details.

