base:
  'Env:{{cookiecutter.environment}}':
    - match: grain
    - cloudformation
    - keys
    - {{cookiecutter.environment}}
    - {{cookiecutter.environment}}-secrets
    - {{cookiecutter.environment}}_containers
    - {{cookiecutter.environment}}_containers-secrets
{% if cookiecutter.with_monitoring == True %}
    - {{cookiecutter.environment}}_monitoring
    - {{cookiecutter.environment}}_monitoring-secrets
{% endif %}

{% raw %}
{% if salt['grains.get']('custom_grain_error', False) %}
A_CUSTOM_GRAIN_FAILED_TO_REFRESH_SO_WE_ARE_BREAKING_THE_YAML_TO_STOP_THE_HIGHSTATE_CONTINUING
{% endif %}
{% endraw %}