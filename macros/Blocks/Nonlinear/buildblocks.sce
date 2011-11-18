// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildblocks()
  macros_path = get_absolute_file_path("buildblocks.sce");
  blocks = ["CBN_Hysteresis"
            "CBN_RateLimiter"
            "MBN_DeadZone"
            "MBN_Limiter"]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
endfunction

buildblocks();
clear buildblocks;