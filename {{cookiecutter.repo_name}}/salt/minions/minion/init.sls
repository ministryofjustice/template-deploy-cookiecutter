/etc/init/salt-minion.conf:
  file:
    - managed
    - source: salt://minions/master/templates/salt-minion.conf
    - template: jinja

/etc/salt/minion:
  file.managed:
    - source: salt://minions/templates/minion

salt-minion:
  service:
    - running
    - enable: True
    - require:
      - file: /etc/init/salt-minion.conf
    - watch:
      - file: /etc/salt/minion

{% set my_environment_name = salt['grains.get']('environment_name') %}
{% set mroles = salt['grains.get']('roles') %}
{% set my_role = mroles[0] %}
/usr/local/bin/salt-call state.highstate:
{% if salt['pillar.get']('apps:' ~ my_role ~ ':cron_highstate:' ~ my_environment_name) %}
  cron.present:
    - user: root
    - minute: '*/30'
{% else %}
  cron.absent:
    - user: root
{% endif %}