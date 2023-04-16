# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

Transparent Huge Pages support is managed:
{%- if redis.system.transparent_huge_pages is false %}
  service.running:
{%- else %}
  service.dead:
{%- endif %}
    - name: {{ salt["file.basename"](redis.lookup.transparent_hugepage_unit) }}
    - enable: {{ redis.system.transparent_huge_pages is false }}

Overcommit memory setting is managed:
  sysctl.present:
    - name: vm.overcommit_memory
    - value: {{ redis.system.overcommit_memory | int }}
