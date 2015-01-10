{% from "netbanner/map.jinja" import netbanner with context %}

include:
  - netbanner

CustomSettings:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomSettings'
    - value: {{ netbanner.CustomSettings }}
    - vtype: REG_DWORD
    - reflection: True
    - listen_in:
      - cmd: netbanner

CustomBackgroundColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomBackgroundColor'
    - value: {{ netbanner.CustomBackgroundColor }}
    - vtype: REG_DWORD
    - reflection: True
    - listen_in:
      - cmd: netbanner

CustomForeColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomForeColor'
    - value: {{ netbanner.CustomForeColor }}
    - vtype: REG_DWORD
    - reflection: True
    - listen_in:
      - cmd: netbanner

CustomDisplayText:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomDisplayText'
    - value: '{{ netbanner.CustomDisplayText }}'
    - vtype: REG_SZ
    - reflection: True
    - listen_in:
      - cmd: netbanner

#'onchanges' doesn't support execution when *any* state changes, only all of them.
#When that's supported, 'onchanges' will replace the 'listen_in' requisites
