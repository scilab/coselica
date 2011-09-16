// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildblocks()
  macros_path = get_absolute_file_path("buildblocks.sce");
  blocks = ["CBI_RealInput"
            "CBI_RealOutput"]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
  tbx_build_pal(toolbox_dir, "Interfaces", "CoselicaBlocksInterfaces.xpal", blocks)
endfunction

buildblocks();
clear buildblocks;