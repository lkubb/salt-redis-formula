# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Redis is installed:
  pkg.installed:
    - name: {{ redis.lookup.pkg.name }}

Redis service overrides are installed:
  file.managed:
    - name: /etc/systemd/system/{{ redis.lookup.service.name }}.d/override.conf
    - source: {{ files_switch(["redis-override.conf", "redis-override.conf.j2"],
                              lookup="Redis service overrides are installed"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ redis.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - require:
      - Redis is installed
    - context:
        redis: {{ redis | json }}

Service managing Transparent Huge Pages is installed:
  file.managed:
    - name: {{ redis.lookup.transparent_hugepage_unit }}
    - source: {{ files_switch(["redis-huge-pages.service", "redis-huge-pages.service.j2"],
                              lookup="Service managing Transparent Huge Pages is installed"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ redis.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - require:
      - Redis is installed
    - context:
        redis: {{ redis | json }}
