# vim: ft=sls

{#-
    This state will remove the configured redis repository.
    This works for apt/dnf/yum/zypper-based distributions only by default.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}


{%- if redis.lookup.pkg_manager not in ["apt", "dnf", "yum", "zypper"] %}
{%-   if salt["state.sls_exists"](slsdotpath ~ "." ~ redis.lookup.pkg_manager ~ ".clean") %}

include:
  - {{ slsdotpath ~ "." ~ redis.lookup.pkg_manager ~ ".clean" }}
{%-   endif %}

{%- else %}
{%-   for reponame, enabled in redis.lookup.enablerepo.items() %}
{%-     if enabled %}

Redis {{ reponame }} repository is absent:
  pkgrepo.absent:
{%-       for conf in ["name", "ppa", "ppa_auth", "keyid", "keyid_ppa", "copr"] %}
{%-         if conf in redis.lookup.repos[reponame] %}
    - {{ conf }}: {{ redis.lookup.repos[reponame][conf] }}
{%-         endif %}
{%-       endfor %}
{%-     endif %}
{%-   endfor %}
{%- endif %}
