# == Class: python
#
# Install python2 and python3
#
class python (
) {
  package { ['python', 'python3']: }
}
