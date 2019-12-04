{% from "bookkeeper/map.jinja" import bookkeeper with context %}

include:
  - .service

bookkeeper:
  pkg.installed:
    - pkgs: {{ bookkeeper.pkgs }}
    - require_in:
        - service: bookkeeper_service_running
