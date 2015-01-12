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
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomSettings'
    - value: {{ netbanner.CustomSettings }}
    - vtype: REG_DWORD
    - reflection: True
    - require:
      - pkg: netbanner
    - listen_in:
      - cmd: netbanner

CustomBackgroundColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomBackgroundColor'
    - value: {{ netbanner.CustomBackgroundColor }}
    - vtype: REG_DWORD
    - reflection: True
    - require:
      - pkg: netbanner
    - listen_in:
      - cmd: netbanner

CustomForeColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomForeColor'
    - value: {{ netbanner.CustomForeColor }}
    - vtype: REG_DWORD
    - reflection: True
    - require:
      - pkg: netbanner
    - listen_in:
      - cmd: netbanner

CustomDisplayText:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomDisplayText'
    - value: '{{ netbanner.CustomDisplayText }}'
    - vtype: REG_SZ
    - reflection: True
    - require:
      - pkg: netbanner
    - listen_in:
      - cmd: netbanner

#'onchanges' doesn't support execution when *any* state changes, only all of them.
#When that's supported, 'onchanges_in' will replace the 'listen_in' requisites.
