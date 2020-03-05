{% from "bookkeeper/map.jinja" import bookkeeper with context %}

{% for pkg in bookkeeper.pkgs %}
test_{{pkg}}_is_installed_for_bookkeeper:
  testinfra.package:
    - name: {{ pkg }}
    - is_installed: True
{% endfor %}

test_bookkeeper_archive_installed:
  testinfra.file:
    - name: /opt/bookkeeper-server
    - exists: True
    - is_symlink: True
    - linked_to:
        expected: /opt/bookkeeper-server-{{ bookkeeper.version }}
        comparison: eq
    - user:
        expected: {{ bookkeeper.user }}
        comparison: eq
    - group:
        expected: {{ bookkeeper.group }}
        comparison: eq

{% for dirname in bookkeeper.config.ledgerDirectories.split(',') %}
test_ledger_directory_{{ dirname }}_exists:
  testinfra.file:
    - name: {{ dirname }}
    - exists: True
    - user:
        expected: {{ bookkeeper.user }}
        comparison: eq
    - group:
        expected: {{ bookkeeper.group }}
        comparison: eq
{% endfor %}

{% for dirname in bookkeeper.config.journalDirectories.split(',') %}
test_journal_directory_{{ dirname }}_exists:
  testinfra.file:
    - name: {{ dirname }}
    - exists: True
    - user:
        expected: {{ bookkeeper.user }}
        comparison: eq
    - group:
        expected: {{ bookkeeper.group }}
        comparison: eq
{% endfor %}

test_bookkeeper_service_running:
  testinfra.service:
    - name: {{ bookkeeper.service }}
    - is_running: True
    - is_enabled: True
