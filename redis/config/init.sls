# vim: ft=sls

{#-
    Manages the Redis-relevant system and redis service configuration.
    Has a dependency on `redis.package`_.
#}

include:
  - .system
  - .file
