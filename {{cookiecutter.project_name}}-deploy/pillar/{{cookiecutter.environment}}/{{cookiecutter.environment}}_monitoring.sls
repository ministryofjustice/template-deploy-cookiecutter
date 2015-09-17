docker_envs:
  {{cookiecutter.project_name}}.{{cookiecutter.master_zone}}:
    containers:
      stunnel:
        location: /stunnel
        name: platforms/stunnel
        ports:
          app:
            host: 6379
            container: 6379

beaver:
  redis:
    host: localhost
    port: 6379
    namespace: "logstash:{{ cookiecutter.project_name }}"
    db: 0