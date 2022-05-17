# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

redis-config-file-file-managed:
  file.managed:
    - name: {{ redis.lookup.config }}
    - source: {{ files_switch(['redis.conf', 'redis.conf.j2'],
                              lookup='redis-config-file-file-managed'
                 )
              }}
    - mode: 644
    - user: root
    - group: {{ redis.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        redis: {{ redis | json }}
