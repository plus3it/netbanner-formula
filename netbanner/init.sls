{% from "netbanner/map.jinja" import netbanner with context %}

#Get the latest installed version of .NET
{% set dotnet_version = salt['cmd.run'](
    '(Get-ChildItem "HKLM:\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP" -recurse | \
     Get-ItemProperty -name Version -EA 0 | \
     Where { $_.PSChildName -match "^(?!S)\p{L}"} | \
     Select Version | Sort -Descending Version | Select -First 1).Version', 
    shell='powershell') 
%}

#Check if minimum required .NET version is available
{% if dotnet_version[:1] not in netbanner.dotnet_versions %}
#Fail due to missing .NET prerequisite
prereq_dotnet_{{ netbanner.dotnet_versions | join('_') | string }}:
  test.configurable_test_state:
    - name: '.NET {{ netbanner.dotnet_versions | join(', ') | string }} prerequisite'
    - changes: False
    - result: False
    - comment: 'Netbanner {{ netbanner.version | string }} requires a .NET version in this list: {{ netbanner.dotnet_versions | join(', ') | string }}. Detected .NET version: {{ dotnet_version | string }}'

{% else %}
#Install and Apply Netbanner Settings
netbanner:
  pkg.installed:
    - name: 'Netbanner'
    - version: {{ netbanner.version }}
    - listen_in:
      - cmd: netbanner
  cmd.run:
    - name: 'Get-Process | where {$_.ProcessName -match "NetBanner"} | Stop-Process; Start-Process "{{ netbanner.netbanner_exe }}"'
    - shell: powershell

#The 'listen_in' requisite results in the cmd.run state executing every time,
#rather than only when there are changes. It works, but not ideal.
#'onchanges' doesn't support execution when *any* state changes, only all of them.
#When that's supported, 'onchanges_in' will replace the 'listen_in' requisite

NetBanner.admx:
  file.managed:
    - name: {{ netbanner.admx_name }}
    - source: {{ netbanner.admx_source }}
    - require:
      - pkg: netbanner

NetBanner.adml:
  file.managed:
    - name: {{ netbanner.adml_name }}
    - source: {{ netbanner.adml_source }}
    - require:
      - pkg: netbanner

{% endif %}
