// This file is released under the 3-clause BSD license. See COPYING-BSD.

function runMe()
    sources_blocks = ["CHP_Reservoir"
                        "CHS_Pump"
                      
                     ]
    piping_blocks = ["CHP_Pipe"
                    "CHP_Junction"
                        ]

//    sensors_blocks = ["CHP_Pipe"
//                     ]
                     
    blocks = [sources_blocks
              piping_blocks
            //  sensors_blocks
             ]
    toolbox_dir = get_absolute_file_path("hydraulic_hydraulictransfer.sce")+".."
    xpal = tbx_build_pal(toolbox_dir, "Sources", sources_blocks)
    xcosPalAdd(xpal, ['Coselica', "Hydraulic Transfer"]);
    xpal = tbx_build_pal(toolbox_dir, "Piping", piping_blocks)
    xcosPalAdd(xpal, ['Coselica', "Hydraulic Transfer"]);
//    xpal = tbx_build_pal(toolbox_dir, "Sensors", sensors_blocks)
//    xcosPalAdd(xpal, ['Coselica', "Hydraulic Transfer"]);

endfunction

runMe();
clear runMe;
