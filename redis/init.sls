# vim: ft=sls

{#-
    *Meta-state*.

    This installs the redis package,
    manages the redis configuration file
    and then starts the associated redis service.
#}

include:
  - .package
  - .config
  - .service
