{% from "netbanner/map.jinja" import netbanner with context %}

# This sls file will install Microsoft Netbanner and update the Local Group
# Policy Editor configuration so that the Netbanner settings can be managed
# via LGPO.

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
#  - Salt 2015.8.0 or greater (required for templating winrepo packages).
#  - Properly configured salt winrepo package manager, in a master or
#    masterless configuration.
#  - Package definition for Netbanner must be available in the winrepo
#    database. The installer can be obtained from the site(s) listed above.

#Check whether .NET is installed and meets the compatibility requirement
netbanner_prereq_dotnet_{{ netbanner.dotnet_compatibility | join('_') }}:
  cmd.run:
    - name: '
      if (
        @(
          @( {{ netbanner.dotnet_compatibility | join(',') }} ) |
            where {
              ( ( Get-ChildItem
                    "HKLM:\\SOFTWARE\\Microsoft\\NET Framework Setup\\NDP"
                    -recurse |
                  Get-ItemProperty -name Version -EA 0 |
                  where { $_.PSChildName -match "^(?!S)\p{L}" } |
                  Select Version |
                  Sort -Unique
                ) |
                foreach-object { $_.Version.Substring(0,1) }
              )
              -contains
              $_
            }
        ).Count
      ) {
        echo ".NET requirement satisfied."; exit 0
      } else {
        echo "Failed .NET requirement."; exit 1
      }'
    - shell: 'powershell'

#Install Netbanner Settings
netbanner:
  pkg.installed:
    - name: 'netbanner'
    - version: {{ netbanner.version }}
    - allow_updates: True
    - require:
      - cmd: netbanner_prereq_dotnet_{{ netbanner.dotnet_compatibility | join('_') | string }}

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
