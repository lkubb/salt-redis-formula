# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

redis-service-clean-service-dead:
  service.dead:
    - name: {{ redis.lookup.service.name }}
    - enable: False
