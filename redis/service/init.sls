# vim: ft=sls

{#-
    Starts the redis service and enables it at boot time.
    Has a dependency on `redis.config`_.
#}

include:
  - .running
