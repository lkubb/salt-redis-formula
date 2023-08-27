# vim: ft=yaml
---
redis:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    enablerepo:
      keydb: false
    aclfile: users.acl
    config:
      keydb: /etc/keydb/keydb.conf
      redis: /etc/redis/redis.conf
    pkg:
      keydb:
        name: keydb-server
      redis:
        name: redis-server
    service:
      keydb:
        name: keydb-server
      redis:
        name: redis-server
    socket:
      path: /var/run/redis/redis.sock
      perms: '770'
    transparent_hugepage: /sys/kernel/mm/transparent_hugepage
    transparent_hugepage_unit: /etc/systemd/system/redis-huge-pages.service
    user:
      keydb:
        group: keydb
        name: keydb
      redis:
        group: redis
        name: redis
  config: {}
  port: 6379
  service:
    protect_system_full: true
  socket: false
  system:
    overcommit_memory: true
    transparent_huge_pages: false
  users: {}
  variant: redis

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://redis/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   redis-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      redis-config-file-file-managed:
        - 'example.tmpl.jinja'

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
