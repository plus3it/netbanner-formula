# Settings configured in pillar will override default settings specified in
# map.jinja.

netbanner:
  lookup:

    # 'version' must match the netbanner version available from winrepo. Known
    # versions of Netbanner include:
    #   - 1.3.93
    #   - 2.1.161
    # 'admx_source' and 'adml_source' must be a location where the
    # netbanner.admx and netbanner.adml files are available to the salt file
    # system. These files are distributed with this formula, so it is expected
    # that the default path will work for most use cases.

    version: '2.1.161'
    admx_source: 'salt://netbanner/netbannerfiles/netbanner.admx'
    adml_source: 'salt://netbanner/netbannerfiles/netbanner.adml'

    # 'network_label' is associated with a group of netbanner configuration
    # settings to apply to the system.

    network_label: 'purplenetwork'

    #Use the dictionary 'custom_network_labels' to create customized groups of
    # Netbanner settings for your systems. The color key below identifies all
    # the supported background and foreground colors. The label (i.e.
    # purplenetwork) can be specified as the 'network_label' value, above.

    #Background Color Key
    ### Black       = 6
    ### Blue        = 2
    ### Green       = 1
    ### Orange      = 9
    ### Purple      = 8
    ### Red         = 3
    ### SaddleBrown = 7
    ### White       = 5
    ### Yellow      = 4

    #Foreground (Text) Color Key
    ### Black       = 1
    ### Red         = 3
    ### White       = 2

    custom_network_labels:
      purplenetwork:
        CustomBackgroundColor: '8'
        CustomDisplayText: 'This is a purple network banner'
        CustomForeColor: '2'
      bluenetwork:
        CustomBackgroundColor: '2'
        CustomDisplayText: 'This is a blue network banner'
        CustomForeColor: '2'
