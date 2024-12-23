.. _readme:

Redis Formula
=============

|img_sr| |img_pc|

.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release
.. |img_pc| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :alt: pre-commit
   :scale: 100%
   :target: https://github.com/pre-commit/pre-commit

Manage Redis (or KeyDB) with Salt.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltproject.io/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please refer to:

- `how to configure the formula with map.jinja <map.jinja.rst>`_
- the ``pillar.example`` file
- the `Special notes`_ section

Special notes
-------------
* This formula also supports KeyDB. Enable by setting ``variant: keydb`` and (usually) by enabling the keydb repository in ``lookup:enablerepo``.

Configuration
-------------
An example pillar is provided, please see `pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in `map.jinja`.


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



Contributing to this repo
-------------------------

Commit messages
^^^^^^^^^^^^^^^

**Commit message formatting is significant!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``. ::

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
