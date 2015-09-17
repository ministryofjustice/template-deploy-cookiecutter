{% if cookiecutter.with_monitoring == "True" %}
include:
  - logstash.client

{% from 'logstash/lib.sls' import logship with context %}
{{ logship('cron', '/var/log/cron.log', 'cron', ['cron'], 'json') }}
{{ logship('syslog', '/var/log/syslog', 'syslog', ['syslog'], 'json') }}
{{ logship('docker', '/var/lib/docker/containers/*/*-json.log', 'docker_json', ['docker'], 'rawjson') }}
{{ logship('nginx_json', '/var/log/nginx/*.json', 'nginx_json', ['nginx'], 'rawjson') }}
{% endif %}

base:
  '*':
    - moj-docker-deploy
