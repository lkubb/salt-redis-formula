Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``redis``
^^^^^^^^^
*Meta-state*.

This installs the redis package,
manages the redis configuration file
and then starts the associated redis service.


``redis.package``
^^^^^^^^^^^^^^^^^
Installs the redis package only.


``redis.package.repo``
^^^^^^^^^^^^^^^^^^^^^^
This state will install the configured redis repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``redis.config``
^^^^^^^^^^^^^^^^
Manages the Redis-relevant system and redis service configuration.
Has a dependency on `redis.package`_.


``redis.config.file``
^^^^^^^^^^^^^^^^^^^^^



``redis.config.system``
^^^^^^^^^^^^^^^^^^^^^^^



``redis.cert``
^^^^^^^^^^^^^^
Generates a TLS certificate + key for Redis.
Depends on `redis.package`_.


``redis.service``
^^^^^^^^^^^^^^^^^
Starts the redis service and enables it at boot time.
Has a dependency on `redis.config`_.


``redis.clean``
^^^^^^^^^^^^^^^
*Meta-state*.

Undoes everything performed in the ``redis`` meta-state
in reverse order, i.e.
stops the service,
removes the configuration file and then
uninstalls the package.


``redis.package.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the redis package.
Has a dependency on `redis.config.clean`_.


``redis.package.repo.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This state will remove the configured redis repository.
This works for apt/dnf/yum/zypper-based distributions only by default.


``redis.config.clean``
^^^^^^^^^^^^^^^^^^^^^^
Removes the configuration of the redis service and redis-relevant
system configuration and has a
dependency on `redis.service.clean`_.


``redis.cert.clean``
^^^^^^^^^^^^^^^^^^^^
Removes generated Redis TLS certificate + key.
Depends on `redis.service.clean`_.


``redis.service.clean``
^^^^^^^^^^^^^^^^^^^^^^^
Stops the redis service and disables it at boot time.


