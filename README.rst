==========
bookkeeper
==========

SaltStack formula for deploying and maintaining Apache Bookkeeper

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Available states
================

.. contents::
    :local:

``bookkeeper``
--------------

TODO - add description of this state

``bookkeeper.install``
-------------------

Handles installation of bookkeeper

``bookkeeper.config``
-------------------

Handles configuration of bookkeeper

Deployment Notes
================

The instance that you are deploying to should have a minimum of two disks so that the ``journalDirectory`` and ``ledgerDirectories`` settings can be pointed at different disks. This is for performance optimization purposes.

Template
========

This formula was created from a cookiecutter template.

See https://github.com/mitodl/saltstack-formula-cookiecutter.
