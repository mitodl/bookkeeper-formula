{% from "bookkeeper/map.jinja" import bookkeeper with context %}
{% set mirror_data = 'https://www.apache.org/dyn/closer.cgi/bookkeeper?as_json=1'|http_query %}
{% set mirror_paths = mirror_data.body|load_json %}
{% set mirror_path = mirror_paths.preferred %}

include:
  - .service
  - .config

create_bookkeeper_user:
  user.present:
    - name: {{ bookkeeper.user }}
    - shell: /bin/false
    - require_in:
        - service: bookkeeper_service_running

install_bookkeeper_dependencies:
  pkg.installed:
    - pkgs: {{ bookkeeper.pkgs }}
    - require_in:
        - service: bookkeeper_service_running

install_bookkeeper_from_archive:
  archive.extracted:
    - name: /opt/
    - source: {{ mirror_path }}bookkeeper/bookkeeper-{{ bookkeeper.version }}/bookkeeper-server-{{ bookkeeper.version }}-bin.tar.gz
    - source_hash: {{ mirror_paths.backup[0] }}bookkeeper/bookkeeper-{{ bookkeeper.version }}/bookkeeper-server-{{ bookkeeper.version }}-bin.tar.gz.sha512
    - user: {{ bookkeeper.user }}
    - group: {{ bookkeeper.group }}
    - require_in:
        - service: bookkeeper_service_running

create_service_definition:
  file.managed:
    - name: /etc/systemd/system/bookie.service
    - source: salt://bookkeeper/templates/bookie.service.j2
    - template: jinja
    - require_in:
        - service: bookkeeper_service_running
    - require:
        - archive: install_bookkeeper_from_archive
  cmd.wait:
    - name: systemctl daemon-reload
    - watch:
        - file: create_service_definition
    - require_in:
        - service: bookkeeper_service_running

# It is recommended to place these directories on different disks for better performance
# https://bookkeeper.apache.org/docs/4.10.0/admin/bookies/#performance
{% for dirname in bookkeeper.config.ledgerDirectories.split(',') %}
create_ledger_directory:
  file.directory:
    - name: {{ dirname }}
    - user: {{ bookkeeper.user }}
    - group: {{ bookkeeper.group }}
    - recurse:
        - user
        - group
    - require_in:
        - service: bookkeeper_service_running
{% endfor %}

{% for dirname in bookkeeper.config.journalDirectories.split(',') %}
create_journal_directory:
  file.directory:
    - name: {{ dirname }}
    - user: {{ bookkeeper.user }}
    - group: {{ bookkeeper.group }}
    - recurse:
        - user
        - group
    - require_in:
        - service: bookkeeper_service_running
{% endfor %}

create_bookkeeper_log_directory:
  file.directory:
    - name: /var/log/bookkeeper
    - user: {{ bookkeeper.user }}
    - group: {{ bookkeeper.group }}
    - recurse:
        - user
        - group
