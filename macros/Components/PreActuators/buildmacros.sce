// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildmacros()
    macros_path = get_absolute_file_path("buildmacros.sce");
    tbx_build_macros(TOOLBOX_NAME+"_CP_", macros_path);
endfunction

function buildblocks()
    macros_path = get_absolute_file_path("buildmacros.sce");

    preactuators_blocks = [
        "MEMC_Q4driver"
        "MEMC_Q1driver"
        "CCP_PWM"
                   ]


    blocks = [
        preactuators_blocks
             ]

    tbx_build_blocks(toolbox_dir, blocks, macros_path);
endfunction

buildmacros();
getd(get_absolute_file_path("buildmacros.sce"));
buildblocks();
clear buildmacros; // remove buildmacros on stack
