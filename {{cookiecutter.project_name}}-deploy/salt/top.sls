base:
  '*':
    - moj-docker-deploy
{% if cookiecutter.with_monitoring == True %}
    - logs
{% endif %}
