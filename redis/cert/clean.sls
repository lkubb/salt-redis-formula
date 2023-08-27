# vim: ft=sls

{#-
    Removes generated Redis TLS certificate + key.
    Depends on `redis.service.clean`_.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_service_clean = tplroot ~ ".service.clean" %}
{%- from tplroot ~ "/map.jinja" import mapdata as influxdb with context %}

include:
  - {{ sls_service_clean }}

{%- if redis.cert.generate %}

Redis key/cert is absent:
  file.absent:
    - names:
      - {{ redis.lookup.cert.privkey }}
      - {{ redis.lookup.cert.cert }}
    - require:
      - sls: {{ sls_service_clean }}
{%- endif %}
