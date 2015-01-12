# netbanner-formula
This salt formula will install and configure Microsoft Netbanner. Local Group 
Policy Object (LGPO) files will be updated so that Netbanner can be managed 
from the Local Group Policy Editor (i.e. gpedit.msc).

## Dependencies
  - Microsoft .NET 4 for Netbanner 2.x.
  - Microsoft .NET 2 for Netbanner 1.x.
  - Salt 2014.7.0 or greater (required for the 'test' state).
  - Properly configured salt winrepo package manager, in a master or 
    masterless configuration.
  - Package definition for Netbanner must be available in the winrepo 
    database. The installer can be obtained from the link above.

## Available States

### netbanner
This state will install Microsoft Netbanner and update the Local Group Policy 
Editor configuration so that the Netbanner settings can be managed via LGPO. 
The sls will also start|restart the 'Netbanner' process.

### netbanner.custom

This sls file will apply a Netbanner configuration to the system. Netbanner
will be installed if it is not already, via the 'include' statement. The 
Netbanner configuration is read from map.jinja, which supports customization 
via pillar. Any configuration that results in a change will also restart the
'Netbanner' process to read the change and display the configured banner.

## Configuration
The Netbanner configuration is customizable via pillar. The 'lookup' dictionary
contains three settings:
  - version
  - admx_source
  - adml_source

`version` must match the netbanner version available from winrepo. Known
versions of Netbanner include:
  - 1.3.93
  - 2.1.161
`admx_source` and `adml_source` must be a location where the netbanner.admx 
and netbanner.adml files are available to the salt file system. These files 
are distributed with this formula, so it is expected that the default path 
will work for most use cases.

The next configuration setting is `network_label`. The network_label
corresponds to a group of Netbanner settings that many systems may have in
common. There are four default network_labels specified in map.jinja:
  - Unclass
  - NIPR
  - SIPR
  - JWICS

Additional network labels may be created with the `custom_network_labels`
dictionary in the netbanner pillar. Custom labels will be merged with the 
default labels above. Custom labels are defined in a YAML dictionary and 
require three settings:
  - `CustomBackgroundColor`
  - `CustomDisplayText`
  - `CustomForeColor`

All of these settings correspond to registry entries read by the Netbanner
process.

`CustomBackgroundColor` is a number (in string format) from 1-9.
  - Green       = '1'
  - Blue        = '2'
  - Red         = '3'
  - Yellow      = '4'
  - White       = '5'
  - Black       = '6'
  - SaddleBrown = '7'
  - Purple      = '8'
  - Orange      = '9'
`CustomDisplayText` is the string to display in the banner.
`CustomForeColor` is a number (in string format) from 1-3.
  - Black       = '1'
  - White       = '2'
  - Red         = '3'

A complete pillar configuration would look something like this:

    netbanner:
      lookup:
        version: '2.1.161' 
        admx_source: 'salt://netbanner/netbannerfiles/netbanner.admx'
        adml_source: 'salt://netbanner/netbannerfiles/netbanner.adml'

      network_label: 'purplenetwork'

      custom_network_labels:
        purplenetwork:
          CustomBackgroundColor: '8'
          CustomDisplayText: 'This is a purple network banner'
          CustomForeColor: '2'

##TODO
  - [ ] Write a .NET formula that can be included sanely, while avoiding 
        unnecessary downloads and installs, and accounting for the odd .NET 
        deltas across different versions of the Microsoft OS. For example, .NET
        4.5.x will never show up in "installed software" on Windows 2012 R2, 
        but it does on earlier versions. This largely breaks the salt winrepo 
        functionality.
