# Ansible role for MetricBeat

An Ansible Role that installs MetricBeat on Red Hat/CentOS or Debian/Ubuntu.

Special thanks to Emiliano Castagnari (https://github.com/torian) for his 
Filebeat role. This role is based on the code of
 https://github.com/torian/ansible-role-filebeat

## Tested On

  * EL / Centos (6 / 7)
  * Debian (Wheezy / Jessie)
  * Ubuntu (Trusty)

## Role Variables

Available variables are listed below, along with their default values as
definied in `defaults/main.yml`.

MetricBeat user and group. If you run MetricBeat with a user other than root make
sure your logs are readable by the MetricBeat user. Add the MetricBeat user to a
privileged group, with access to your logs.

On Ubuntu you would add the user to the `adm` group. On CentOS you can adjust
the permissions with the `setfacl` command, e.g. `sudo setfacl -m g:metricbeat:r
<path>`.

    metricbeat_user: root
    metricbeat_group: root

Create the `metricbeat` user and group.

    metricbeat_create_user: true

MetricBeat version to use.

    metricbeat_version: 5.0.0-alpha4

Make use of the MetricBeat repo (yum or apt).

You may use a URL to install a specific `.deb` or `.rpm`.
To do so, change `metricbeat_use_repo` value to `false`, then (optionally)
adjust the value of `metricbeat_baseurl` (which has a default value set for you).

    metricbeat_use_repo: true

MetricBeat base URL for package download if `metricbeat_use_repo: false`

    metricbeat_baseurl: "https://download.elastic.co/beats/metricbeat"

Start MetricBeat at boot time.

    metricbeat_start_at_boot: true

MetricBeat version upgrade. This option allows package upgrades.

    metricbeat_upgrade: false

MetricBeat configuration file.

    metricbeat_config_file: /etc/metricbeat/metricbeat.yml

The MetricBeat configuration is built based on the variable `metricbeat_config`.
For easier management of the contents, the `metricbeat_config` variable is made
up of multiple other variables:

* `metricbeat_config_modules`
* `metricbeat_config_general`
* `metricbeat_config_processors`
* `metricbeat_config_output`
* `metricbeat_config_logging`

```yaml
metricbeat_config_modules: |
  metricbeat.modules:
    - module: system
      metricsets:
        - cpu
        #- load
        #- core
        - diskio
        - filesystem
        #- fsstat
        - memory
        - network
        - process
      enabled: true
      period: 10s
      processes: ['.*']
      # if true, exports the CPU usage in ticks, together with the percentage values
      cpu_ticks: false
metricbeat_config_general: |
  name: {{ ansible_hostname }}
  # tags: ['tag1','tag2']
  env: {{ env | default('none') }}
  fields_under_root: false
  # ignore_outgoing: true
  # refresh_topology_freq: 10
  # topology_expire: 15
  # queue_size: 1000
  # max_procs:
metricbeat_config_processors: |
  processors:
metricbeat_config_output: |
  output.elasticsearch:
    hosts: [ 'localhost:9200' ]
metricbeat_config_logging: |
  logging:
    to_files: true
    files:
      path: /var/log/metricbeat
      name: metricbeat.log
      rotateeverybytes: 10485760 # = 10MB
      keepfiles: 7
metricbeat_config: |
  {{metricbeat_config_modules}}

  {{metricbeat_config_general}}

  {{metricbeat_config_processors}}

  {{metricbeat_config_output}}

  {{metricbeat_config_logging}}
```

MetricBeat templates (a list of templates to install).
These templates will be copied to the /etc/metricbeat directory
and can be used in the elasticsearch output for example.

https://www.elastic.co/guide/en/beats/metricbeat/current/elasticsearch-output.html#_template

    metricbeat_templates: []

Install MetricBeat default Kibana dashboards
will install the default dashboards shipped with the package.

```yaml
metricbeat_install_default_kibana_dashboards: False
metricbeat_es_user: "metricbeat"
metricbeat_es_password: "secret"
metricbeat_kibana_index: ".kibana"
metricbeat_es_url: "{{ elasticsearch_proto | default('http') }}://{{ elasticsearch_host | default('localhost:9200') }}"
```

## Usage
```yaml
    - hosts: logging
      roles:
        - { role: sirkjohannsen.metricbeat }
```

## License

GPLv3

## Author Information

This role was created in 2016 by Sirk Johannsen.
It is based on the FileBeat role by Emiliano Castagnari:
https://github.com/torian/ansible-role-filebeat

