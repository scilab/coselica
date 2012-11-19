// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildmacros()
  macros_path = get_absolute_file_path("buildmacros.sce");
  tbx_build_macros(TOOLBOX_NAME+"_HY_", macros_path);
endfunction

function buildblocks()
  macros_path = get_absolute_file_path("buildmacros.sce");
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
           // sensors_blocks
           ]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
endfunction

buildmacros();
// Need to load also Blocks/Interfaces
getd(toolbox_dir + filesep() + "macros" + filesep() + "Blocks" + filesep() + "Interfaces")
getd(get_absolute_file_path("buildmacros.sce"));
buildblocks();
clear buildmacros; // remove buildmacros on stack
