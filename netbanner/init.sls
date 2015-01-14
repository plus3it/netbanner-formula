{% from "netbanner/map.jinja" import netbanner with context %}

# This sls file will install Microsoft Netbanner and update the Local Group 
# Policy Editor configuration so that the Netbanner settings can be managed
# via LGPO. The sls will also start|restart the 'Netbanner' process.

#IMPORTANT:
# Microsoft does not distribute the Netbanner package. It is rather difficult
# to come by. Also, the Netbanner license prevents distribution, so we cannot 
# provide it via Github or a CDN. The only known source is below, and it 
# requires a government-provided Common Access Card (CAC) to gain access to the 
# site.
#  - https://software.forge.mil/sf/go/rel3968

#Dependencies:
#  - Microsoft .NET 4 for Netbanner 2.x.
#  - Microsoft .NET 2 for Netbanner 1.x.
#  - Salt 2014.7.0 or greater (required for the 'test' state).
#  - Properly configured salt winrepo package manager, in a master or 
#    masterless configuration.
#  - Package definition for Netbanner must be available in the winrepo 
#    database. The installer can be obtained from the site(s) listed above.

#Get the latest installed version of .NET
{% set dotnet_version = salt['cmd.run'](
    '(Get-ChildItem "HKLM:\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP" \
     -recurse | Get-ItemProperty -name Version -EA 0 | \
     Where { $_.PSChildName -match "^(?!S)\p{L}"} | \
     Select Version | Sort -Descending Version | Select -First 1).Version', 
    shell='powershell') 
%}

#Check if minimum required .NET version is available
#Fail due to missing .NET prerequisite
prereq_dotnet_{{ netbanner.dotnet_versions | join('_') | string }}:
  test.configurable_test_state:
    - name: '.NET {{ netbanner.dotnet_versions | join(', ') | string }} prerequisite'
    - changes: False
{% if dotnet_version[:1] not in netbanner.dotnet_versions %}
    - result: False
    - comment: 'Detected .NET version: {{ dotnet_version | string }}.
                Netbanner {{ netbanner.version | string }} requires a .NET 
                version in this list: 
                {{ netbanner.dotnet_versions | join(', ') | string }}.'
{% else %}
    - result: True
    - comment: '.NET version {{ dotnet_version }} meets minimum requirement 
                for Netbanner {{ netbanner.version }}'
{% endif %}

#Install Netbanner Settings
netbanner:
  pkg.installed:
    - name: 'Netbanner'
    - version: {{ netbanner.version }}
    - require:
      - test: prereq_dotnet_{{ netbanner.dotnet_versions | join('_') | string }}
  cmd.run:
    - name: 'Get-Process | where {$_.ProcessName -match "NetBanner"} | Stop-Process; 
             Start-Process "{{ netbanner.netbanner_exe }}"'
    - shell: powershell
    - require:
      - pkg: netbanner

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
