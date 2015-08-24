base:
  'Env:{{cookiecutter.environment}}':
    - match: grain
    - {{cookiecutter.environment}}
    # - dev-secrets
    - cloudformation
