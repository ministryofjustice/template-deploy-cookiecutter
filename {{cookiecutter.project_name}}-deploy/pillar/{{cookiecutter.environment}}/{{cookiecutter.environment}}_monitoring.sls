docker_envs:
  {{cookiecutter.dns_name}}.{{cookiecutter.master_zone}}:
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

syslog:
  udp_enabled: False

collectd:
  FQDNLookup: false
  TypesDB: ['/usr/share/collectd/types.db']
  plugins:
    default: [cpu, entropy, load, memory, swap, users, write_graphite, ethstat, interface, df, disk, python]
    enable: true
    write_graphite:
      host: localhost
      port: "2003"
      prefix: "collectd.postcodeinfo"
      postfix: ""
      protocol: "tcp"
      logsenderrors: false
      escapecharacter: "_"
      separateinstances: true
      storerates: true
      alwaysappendds: false
    ethstat:
      interface: 'eth0'
    interface:
      interfaces: ['eth0', 'lo0']
      IgnoreSelected: 'false'
    ping:
      hosts: ['google.com', 'yahoo.com']
      interval: 1.0
      timeout: 0.9
      ttl: 64
      #sourceaddress: 10.0.1.1
      device: eth0
      maxmissed: -1
    disk:
      matches: ['/^[hsx]v?d[a-f][0-9]?$/']
    processes:
      - python
    df:
      MountPoints:
        - '/'
        - '/data'
      FsTypes:
        - 'ext4'
        - 'tmpfs'
      ReportInodes: "true"
      ValuesPercentage: "true"
    python:
      Globals: true
      LogTraces: true
      Interactive: false
      modules:
        - name: ntpoffset
          variables:
            pool: '"ie.pool.ntp.org"'
            absolutes: "true"