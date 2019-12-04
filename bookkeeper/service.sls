{% from "bookkeeper/map.jinja" import bookkeeper with context %}

bookkeeper_service_running:
  service.running:
    - name: {{ bookkeeper.service }}
    - enable: True
