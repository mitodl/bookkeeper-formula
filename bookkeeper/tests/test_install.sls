{% from "bookkeeper/map.jinja" import bookkeeper with context %}

{% for pkg in bookkeeper.pkgs %}
test_{{pkg}}_is_installed:
  testinfra.package:
    - name: {{ pkg }}
    - is_installed: True
{% endfor %}
