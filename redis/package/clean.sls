# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

include:
  - {{ sls_config_clean }}

Redis service modifications are removed:
  file.absent:
    - names:
      - /etc/systemd/system/{{ redis.lookup.service.name }}.d/override.conf
      - /etc/systemd/system/redis-huge-pages.service

redis-package-clean-pkg-removed:
  pkg.removed:
    - name: {{ redis.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
