docker_envs:
  {{cookiecutter.dns_name}}.{{cookiecutter.master_zone}}:
    nginx_port: 80
    ssl:
      redirect: True
    containers:
      {{cookiecutter.project_name}}:
      {% for container in cookiecutter.containers.split() %}
        name: {{container}}
        http_locations:
          - /ping.json
        location: /
        ports:
          app:
            host: 9080
            container: 80
        envvars:
          ENV_VAR1: value
      {% endfor %}
         
