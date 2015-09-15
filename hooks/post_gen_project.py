import logging
import os
import pkgutil
import subprocess

#
# This cookiecutter post project creation script
#

cmd = 'salt-shaker'
opts = 'install'
subprocess.call([cmd, opts])
