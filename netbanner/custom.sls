{% from "netbanner/map.jinja" import netbanner with context %}

# This sls file will apply a Netbanner configuration to the system. Netbanner
# will be installed if it is not already, via the 'include' statement. The
# Netbanner configuration is read from map.jinja, which supports customization
# via pillar. Any configuration that results in a change will also restart the
# 'Netbanner' process to read the change and display the configured banner.

include:
  - netbanner

CustomSettings:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner'
    - vname: 'CustomSettings'
    - vdata: {{ netbanner.CustomSettings }}
    - vtype: REG_DWORD
    - require:
      - pkg: netbanner

CustomBackgroundColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner'
    - vname: 'CustomBackgroundColor'
    - vdata: {{ netbanner.CustomBackgroundColor }}
    - vtype: REG_DWORD
    - require:
      - pkg: netbanner

CustomForeColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner'
    - vname: 'CustomForeColor'
    - vdata: {{ netbanner.CustomForeColor }}
    - vtype: REG_DWORD
    - require:
      - pkg: netbanner

CustomDisplayText:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner'
    - vname: 'CustomDisplayText'
    - vdata: '{{ netbanner.CustomDisplayText }}'
    - vtype: REG_SZ
    - require:
      - pkg: netbanner

#'onchanges' doesn't support execution when *any* state changes, only all of them.
#When that's supported, 'onchanges_in' will replace the 'watch_in' requisites.
