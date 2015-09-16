docker_envs:
  {{cookiecutter.project_name}}.{{cookiecutter.master_zone}}:
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
      {{cookiecutter.project_apps}}:
        # This is the name of the container as it is tagged
        # in docker
        name: {{cookiecutter.docker_container}}
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

  stunnel:
        location: /stunnel
        name: platforms/stunnel
        ports:
          app:
            host: 6379
            container: 6379
         
