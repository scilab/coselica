// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildblocks()
  macros_path = get_absolute_file_path("buildblocks.sce");
  blocks = ["CBR_DeMultiplex2"
            "CBR_DeMultiplexVector2"
            "CBR_Extractor"
            "CBR_Multiplex2"
            "CBR_MultiplexVector2"
            "CBR_Replicator"]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
  tbx_build_pal(toolbox_dir, "Routing", "CoselicaBlocksRouting.xpal", blocks)

endfunction

buildblocks();
clear buildblocks;