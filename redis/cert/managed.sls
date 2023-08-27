# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_config_file = tplroot ~ ".config.file" %}
{%- from tplroot ~ "/map.jinja" import mapdata as redis with context %}

include:
  - {{ sls_config_file }}

{%- if redis.cert.generate %}

Redis certificate private key is managed:
  x509.private_key_managed:
    - name: {{ redis.lookup.cert.privkey }}
    - algo: rsa
    - keysize: 2048
    - new: true
{%-   if salt["file.file_exists"](redis.lookup.cert.privkey) %}
    - prereq:
      - Redis certificate is managed
{%-   endif %}
    - makedirs: true
    - user: {{ redis.lookup.user[redis.variant].name }}
    - group: {{ redis.lookup.user[redis.variant].group }}
    - require:
      - sls: {{ sls_config_file }}

Redis certificate is managed:
  x509.certificate_managed:
    - name: {{ redis.lookup.cert.cert }}
    - ca_server: {{ redis.cert.ca_server or "null" }}
    - signing_policy: {{ redis.cert.signing_policy or "null" }}
    - signing_cert: {{ redis.cert.signing_cert or "null" }}
    - signing_private_key: {{ redis.cert.signing_private_key or
                              (redis.lookup.cert.privkey if not redis.cert.ca_server and not redis.cert.signing_cert else "null") }}
    - private_key: {{ redis.lookup.cert.privkey }}
    - authorityKeyIdentifier: keyid:always
    - basicConstraints: critical, CA:false
    - subjectKeyIdentifier: hash
{%-   if redis.cert.san %}
    - subjectAltName:  {{ redis.cert.san | json }}
{%-   else %}
    - subjectAltName:
      - dns: {{ redis.cert.cn or ([grains.fqdn] + grains.fqdns) | reject("==", "localhost.localdomain") | first | d(grains.id) }}
      - ip: {{ (grains.get("ip4_interfaces", {}).get("eth0", [""]) | first) or (grains.get("ipv4") | reject("==", "127.0.0.1") | first) }}
{%-   endif %}
    - CN: {{ redis.cert.cn or ([grains.fqdn] + grains.fqdns) | reject("==", "localhost.localdomain") | first | d(grains.id) }}
    - mode: '0640'
    - user: {{ redis.lookup.user[redis.variant].name }}
    - group: {{ redis.lookup.user[redis.variant].group }}
    - makedirs: true
    - append_certs: {{ redis.cert.intermediate | json }}
    - days_remaining: {{ redis.cert.days_remaining }}
    - days_valid: {{ redis.cert.days_valid }}
    - require:
      - sls: {{ sls_config_file }}
{%-   if not salt["file.file_exists"](redis.lookup.cert.privkey) %}
      - Redis certificate private key is managed
{%-   endif %}

Ensure CA certificates are trusted for Redis:
  x509.pem_managed:
    - name: {{ redis.lookup.cert.ca_cert }}
    # ensure root and intermediate CA certs are in the truststore
    - text: {{ ([redis.cert.root] + redis.cert.intermediate) | join("\n") | json }}
    - user: root
    - makedirs: true
    - group: {{ redis.lookup.rootgroup }}
    - mode: '0644'
    - require:
      - sls: {{ sls_config_file }}
{%- endif %}
