# This registry will be used if no registry is set in
# the containers section.
default_registry: registry.service.dsd.io

# This configures the branch runner (don't enable in prod)
# The pillar_path is a string identifying where the container you wish
# to use for the branch runner is defined in the pillar
# The container_to_run identifies which container we want to use as
# a template for the container running the branch
#branch_runner:
#  pillar_path: docker_envs:dev.blah.dsd.io
#  container_base_hostname: dev.blah.dsd.io
#  container_to_run: another_app

nginx:
  version: 1.4.6-1ubuntu3.3