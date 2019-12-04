{% from "bookkeeper/map.jinja" import bookkeeper with context %}

include:
  - .install
  - .service

bookkeeper-config:
  file.managed:
    - name: {{ bookkeeper.conf_file }}
    - source: salt://bookkeeper/templates/conf.jinja
    - template: jinja
    - watch_in:
      - service: bookkeeper_service_running
    - require:
      - pkg: bookkeeper
