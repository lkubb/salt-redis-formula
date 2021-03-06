# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

redis-package-install-pkg-installed:
  pkg.installed:
    - name: {{ redis.lookup.pkg.name }}

Redis service overrides are installed:
  file.managed:
    - name: /etc/systemd/system/{{ redis.lookup.service.name }}.d/override.conf
    - source: {{ files_switch(['redis-override.conf', 'redis-override.conf.j2'],
                              lookup='Redis service overrides are installed'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ redis.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - redis-package-install-pkg-installed
    - context:
        redis: {{ redis | json }}
  module.run:
    - service.systemctl_reload: []
    - onchanges:
      - file: /etc/systemd/system/{{ redis.lookup.service.name }}.d/override.conf

Service managing Transparent Huge Pages is installed:
  file.managed:
    - name: /etc/systemd/system/redis-huge-pages.service
    - source: {{ files_switch(['redis-huge-pages.service', 'redis-huge-pages.service.j2'],
                              lookup='Service managing Transparent Huge Pages is installed'
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ redis.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - require:
      - redis-package-install-pkg-installed
    - context:
        redis: {{ redis | json }}
  module.run:
    - service.systemctl_reload: []
    - onchanges:
      - file: /etc/systemd/system/redis-huge-pages.service
