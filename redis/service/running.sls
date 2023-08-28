# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- set sls_cert_managed = tplroot ~ ".cert.managed" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

include:
  - {{ sls_config_file }}
  - {{ sls_cert_managed }}

Redis is running:
  service.running:
    - name: {{ redis.lookup.service[redis.variant].name }}
    - enable: true
    - watch:
      - sls: {{ sls_config_file }}
      - sls: {{ sls_cert_managed }}
      - file: /etc/systemd/system/{{ redis.lookup.service[redis.variant].name }}.service.d/override.conf
