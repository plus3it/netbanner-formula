{% from "netbanner/map.jinja" import netbanner with context %}

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

CustomBackgroundColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomBackgroundColor'
    - value: {{ netbanner.CustomBackgroundColor }}
    - vtype: REG_DWORD
    - reflection: True
    - require:
      - pkg: netbanner

CustomForeColor:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomForeColor'
    - value: {{ netbanner.CustomForeColor }}
    - vtype: REG_DWORD
    - reflection: True
    - require:
      - pkg: netbanner

CustomDisplayText:
  reg.present:
    - name: 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\NetBanner\CustomDisplayText'
    - value: '{{ netbanner.CustomDisplayText }}'
    - vtype: REG_SZ
    - reflection: True
    - require:
      - pkg: netbanner

netbanner_process:
  cmd.run:
    - name: 'Get-Process | where {$_.ProcessName -match "NetBanner"} | Stop-Process; Start-Process "{{ netbanner.netbanner_exe }}"'
    - shell: powershell
    - require:
      - reg: CustomDisplayText
      - reg: CustomForeColor
      - reg: CustomBackgroundColor
      - reg: CustomSettings
      - pkg: netbanner
#'onchanges' doesn't support execution when *any* state changes, only all of them.
#When that's supported, this block will replace the require block.
#    - onchanges:
#      - reg: CustomDisplayText
#      - reg: CustomForeColor
#      - reg: CustomBackgroundColor
#      - reg: CustomSettings
#      - pkg: netbanner
