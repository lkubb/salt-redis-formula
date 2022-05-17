# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Transparent Huge Pages support is managed:
{%- if false == redis.system.transparent_huge_pages %}
  service.running:
{%- else %}
  service.dead:
{%- endif %}
    - name: {{ redis.lookup.service.name }}
    - enable: {{ false == redis.system.transparent_huge_pages }}

Overcommit memory setting is managed:
  sysctl.present:
    - name: vm.overcommit_memory
    - value: {{ redis.system.overcommit_memory | int }}
