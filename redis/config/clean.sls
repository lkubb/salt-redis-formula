# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

include:
  - {{ sls_service_clean }}

redis-config-clean-file-absent:
  file.absent:
    - name: {{ redis.lookup.config }}
    - require:
      - sls: {{ sls_service_clean }}

Transparent Huge Pages support is unmanaged:
  service.dead:
    - name: {{ redis.lookup.service.name }}
    - enable: false

System does not overcommit memory:
  sysctl.present:
    - name: vm.overcommit_memory
    - value: 0
