# vim: ft=sls

{#-
    Removes the redis package.
    Has a dependency on `redis.config.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_clean = tplroot ~ ".config.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

include:
  - {{ sls_config_clean }}
{%- if redis.variant != "redis" %}
  - {{ slsdotpath }}.repo.clean
{%- endif %}

Redis service modifications are removed:
  file.absent:
    - names:
      - /etc/systemd/system/{{ redis.lookup.service[redis.variant].name }}.service.d/override.conf
      - {{ redis.lookup.transparent_hugepage_unit }}

Redis is removed:
  pkg.removed:
    - name: {{ redis.lookup.pkg[redis.variant].name }}
    - require:
      - sls: {{ sls_config_clean }}
