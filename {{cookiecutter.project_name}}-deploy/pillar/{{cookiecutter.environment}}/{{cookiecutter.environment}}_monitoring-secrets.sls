docker_envs:
  {{cookiecutter.dns_name}}.{{cookiecutter.master_zone}}:
    containers:
{# Setup the stunnel endpoint. Default to the dev one #}
{% if cookiecutter.environment == "prod" %}
{% set stunnel_redis_endpoint = "stunnel-redis.service.dsd.io:6379" %}
{% set stunnel_graphite_endpoint = "stunnel-graphite.service.dsd.io:22003" %}
{% endif %}
{% if cookiecutter.environment == "staging" %}
{% set stunnel_redis_endpoint = "stunnel-redis-stg.service.dsd.io:6379" %}
{% set stunnel_graphite_endpoint = "stunnel-g-staging.service.dsd.io:22003" %}
{% endif %}
      stunnel:
        envvars:
          STUNNEL_SSL: '{"cert":"{{cookiecutter.stunnel_cert}}","chain":"{{cookiecutter.stunnel_chain}}","key":"{{cookiecutter.stunnel_key}}"}'
{% if stunnel_redis_endpoint %}STUNNEL_SERVICE_LOGSTASH: '{"delay": "yes", "retry": "yes", "client": "yes", "accept": "6379", "connect": "{{stunnel_redis_endpoint}}", "verify": 2}'{% endif %}
{% if stunnel_graphite_endpoint %}STUNNEL_SERVICE_GRAPHITE: '{"delay": "yes", "retry": "yes", "client": "yes", "accept": "2003", "connect": "{{stunnel_graphite_endpoint}}", "verify": 2}'{% endif %}