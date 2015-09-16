base:
  'Env:{{cookiecutter.environment}}':
    - match: grain
    - cloudformation
    - {{cookiecutter.environment}}.sls
    - {{cookiecutter.environment}}-secrets.sls
    - {{cookiecutter.environment}}_containers.sls
    - {{cookiecutter.environment}}_containers-secrets.sls
{% if cookiecutter.with_monitoring != False %}
    - {{cookiecutter.environment}}_monitoring.sls
    - {{cookiecutter.environment}}_monitoring-secrets.sls
{% endif %}

{% raw %}
{% if salt['grains.get']('custom_grain_error', False) %}
A_CUSTOM_GRAIN_FAILED_TO_REFRESH_SO_WE_ARE_BREAKING_THE_YAML_TO_STOP_THE_HIGHSTATE_CONTINUING
{% endif %}
{% endraw %}