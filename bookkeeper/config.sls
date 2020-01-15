{% from "bookkeeper/map.jinja" import bookkeeper with context %}

include:
  - .service

configure_bookkeeper:
  file.managed:
    - name: /opt/bookkeeper-server-{{ bookkeeper.version }}/conf/bk_server.conf
    - source: salt://bookkeeper/templates/conf.jinja
    - template: jinja
    - context:
        config: {{ bookkeeper.config|tojson }}
    - watch_in:
      - service: bookkeeper_service_running
    - backup: minion
