# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

# There is no need for python-apt anymore.

{%- for reponame, enabled in redis.lookup.enablerepo.items() %}
{%-   if enabled %}

Redis {{ reponame }} repository is available:
  pkgrepo.managed:
{%-     for conf, val in redis.lookup.repos[reponame].items() %}
    - {{ conf }}: {{ val }}
{%-     endfor %}
{%-     if redis.lookup.pkg_manager in ["dnf", "yum", "zypper"] %}
    - enabled: 1
{%-     endif %}
    - require_in:
      - Redis is installed

{%-   else %}

Redis {{ reponame }} repository is disabled:
  pkgrepo.absent:
{%-     for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-       if conf in redis.lookup.repos[reponame] %}
    - {{ conf }}: {{ redis.lookup.repos[reponame][conf] }}
{%-       endif %}
{%-     endfor %}
    - require_in:
      - Redis is installed
{%-   endif %}
{%- endfor %}
