[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/plus3it/netbanner-formula?branch=master&svg=true)](https://ci.appveyor.com/project/plus3it/netbanner-formula)

# netbanner-formula

This salt formula will install and configure Microsoft Netbanner. Local Group
Policy Object (LGPO) files will be updated so that Netbanner can be managed
from the Local Group Policy Editor (i.e. gpedit.msc).

## IMPORTANT:

Microsoft does not distribute the Netbanner package. It is rather difficult
to come by. Also, the Netbanner license prevents distribution, so we cannot
provide it via Github or a CDN. The only known source is below, and it
requires a government-provided Common Access Card (CAC) to gain access to the
site.

- https://software.forge.mil/sf/go/rel3968

## Dependencies

- Microsoft .NET 4 for Netbanner 2.x.
- Microsoft .NET 2 for Netbanner 1.x.
- Salt 2015.8.0 or greater (required for templating winrepo packages).
- Properly configured salt winrepo package manager, in a master or
masterless configuration.
- Package definition for Netbanner must be available in the winrepo
database. The installer can be obtained from the site(s) listed above.

## Available States

### netbanner

This state will install Microsoft Netbanner and update the Local Group Policy
Editor configuration so that the Netbanner settings can be managed via LGPO.

### netbanner.custom

This sls file will apply a Netbanner configuration to the system. Netbanner
will be installed if it is not already, via an `include` statement. The
Netbanner configuration is read from map.jinja, which supports customization
via pillar. Configuration changes typically require logging out and back in
to become effective (though sometimes force closing and restarting the
Netbanner.exe process will also work).

## Configuration

While the default settings allow the formula to work without any configuration,
the Netbanner formula is customizable via pillar. A complete pillar
configuration would look something like this:

```
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
```

### `netbanner:lookup:version`

`version` must match a netbanner version available from winrepo. Known
versions of Netbanner include:

- 1.3.93
- 2.1.161

### `netbanner:lookup:admx_source` and `netbanner:lookup:adml_source`
`admx_source` and `adml_source` must be a location where the netbanner.admx
and netbanner.adml files are available to the salt file system. These files
are distributed with this formula, so it is expected that the default path
will work for most use cases.

### `netbanner:lookup:network_label`:

The next configuration setting is `network_label`. The `network_label`
corresponds to a group of Netbanner settings that many systems may have in
common. The `network_label` label and associated settings must be defined in
`custom_network_labels`.

### `netbanner:lookup:custom_network_labels`:

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
`CustomDisplayText` is the string to display in the banner. `CustomForeColor`
is a number (in string format) from 1-3.

`CustomBackgroundColor` key:

- Green       = '1'
- Blue        = '2'
- Red         = '3'
- Yellow      = '4'
- White       = '5'
- Black       = '6'
- SaddleBrown = '7'
- Purple      = '8'
- Orange      = '9'

`CustomForeColor` key:

- Black       = '1'
- White       = '2'
- Red         = '3'
