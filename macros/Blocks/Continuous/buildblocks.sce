// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildblocks()
  macros_path = get_absolute_file_path("buildblocks.sce");
  blocks = ["CBC_StateSpace"
            "CBC_TransferFunction"
            "MBC_Der"
            "MBC_Derivative"
            "MBC_FirstOrder"
            "MBC_Integrator"
            "MBC_LimIntegrator"
            "MBC_LimPID"
            "MBC_PI"
            "MBC_PID"
            "MBC_SecondOrder"]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
endfunction

buildblocks();
clear buildblocks;