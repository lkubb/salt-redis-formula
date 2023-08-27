# vim: ft=sls

{#-
    Generates a TLS certificate + key for Redis.
    Depends on `redis.package`_.
#}

include:
  - .managed
