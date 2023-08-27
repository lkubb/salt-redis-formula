# vim: ft=sls

{#-
    Stops the redis service and disables it at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

Redis is dead:
  service.dead:
    - name: {{ redis.lookup.service[redis.variant].name }}
    - enable: false
