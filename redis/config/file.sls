# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Redis configuration is managed:
  file.managed:
    - name: {{ redis.lookup.config }}
    - source: {{ files_switch(
                    ["redis.conf", "redis.conf.j2"],
                    config=redis,
                    lookup="Redis configuration is managed",
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ redis.lookup.rootgroup }}
    - makedirs: true
    - template: jinja
    - require:
      - sls: {{ sls_package_install }}
    - context:
        redis: {{ redis | json }}
