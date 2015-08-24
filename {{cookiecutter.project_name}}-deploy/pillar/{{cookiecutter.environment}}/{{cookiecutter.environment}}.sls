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


# If your registries require a login then specify them
# here. The user and password should be plain text.
#registry_logins:
#  'https://registry.service.dsd.io/v1/':
#    email: platforms@digital.justice.gov.uk
#    user: <in keychain>
#    password: <in keychain>

nginx:
  version: 1.4.6-1ubuntu3.3

docker_envs:
  dev.blah.dsd.io:
    # this is the port you should direct your ELB to
    nginx_port: 80
    ssl:
      # If you enable this and have a custom health
      # check on your ELB you will also want to add
      # the healthcheck location to http_locations
      # below
      redirect: True
    containers:
      # This key is a custom name for the container,
      # it can be anything and is used by salt to name
      # upstart jobs and for the deploy task.
      another_app:
        # This is the name of the container as it is tagged
        # in docker
        name: tutum/hello-world
        # You can use this key to override the default_registry
        # Note, to use the default docker hub registry you need to set the 
        # registry to be empty as shown below
        registry: 
        # This is useful for custom ELB checks
        # if you have the SSL redirect enabled (default)
        http_locations:
          - /ping.json
        # This is the nginx location that is mapped to the container
        location: /
        ports:
          app:
            # This is the port which docker forwards into the container
            # it can be anything as long as it's not in use on the host.
            # it is automatically set as an nginx upstream.
            host: 9080
            # This is the port that the process in the container is
            # listening on.
            container: 80
        # These environment variables will be set in the container
        # note you get some free variables for database details etc.
        envvars:
          ENV_VAR1: value
          ENV_VAR2: value2
          
# These containers are not proxied by nginx
containers:
  # A minimal non-proxied container application
  nonproxied_redis_app:
    name: redis
    registry: 
    ports:
      app:
        host: 6379
        container: 6379
    envvars:
      ENV_VAR1: nonproxied_app_value_1
      ENV_VAR2: nonproxied_app_value_2

