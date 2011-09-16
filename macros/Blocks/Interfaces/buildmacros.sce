// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildmacros()
  macros_path = get_absolute_file_path("buildmacros.sce");
  tbx_build_macros(TOOLBOX_NAME+"_BI_", macros_path);
  lib(macros_path);
  blocks = ["CBI_RealInput"
            "CBI_RealOutput"]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
endfunction

buildmacros();
clear buildmacros; // remove buildmacros on stack