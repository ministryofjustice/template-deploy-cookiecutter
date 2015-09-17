docker_envs:
  {{cookiecutter.project_name}}.{{cookiecutter.master_zone}}:
    containers:
{# Setup the stunnel endpoint. Default to the dev one #}
{% if cookiecutter.environment == "prod" %}{% set stunnel_endpoint = "stunnel-redis.service.dsd.io:6379" %}{% endif %}
{% if cookiecutter.environment == "staging" %}{% set stunnel_endpoint = "stunnel-redis-stg.service.dsd.io:6379" %}{% else %}{% set stunnel_endpoint = "stunnel-redis-dev.service.dsd.io:6379" %}{% endif %}
      stunnel:
        envvars:
          STUNNEL_SSL: '{"cert":"{{cookiecutter.stunnel_cert}}","chain":"{{cookiecutter.stunnel_chain}}","key":"{{cookiecutter.stunnel_key}}"}'
          STUNNEL_SERVICE_LOGSTASH: '{"delay": "yes", "retry": "yes", "client": "yes", "accept": "6379", "connect": "{{stunnel_endpoint}}", "verify": 2}'
  