// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildblocks()
  macros_path = get_absolute_file_path("buildblocks.sce");
  blocks = ["CBMV_Add"
            "CBMV_CrossProduct"
            "CBMV_DotProduct"
            "CBMV_ElementwiseProduct"
            "CBM_Add3"
            "CBM_Atan2"
            "CBM_Sum"
            "CBM_TwoInputs"
            "CBM_TwoOutputs"
            "MBM_Abs"
            "MBM_Acos"
            "MBM_Add"
            "MBM_Asin"
            "MBM_Atan"
            "MBM_Cos"
            "MBM_Cosh"
            "MBM_Division"
            "MBM_Exp"
            "MBM_Feedback"
            "MBM_Gain"
            "MBM_Log"
            "MBM_Log10"
            "MBM_Max"
            "MBM_Min"
            "MBM_Product"
            "MBM_Sign"
            "MBM_Sin"
            "MBM_Sinh"
            "MBM_Sqrt"
            "MBM_Tan"
            "MBM_Tanh"]

  tbx_build_blocks(toolbox_dir, blocks, macros_path);
endfunction

buildblocks();
clear buildblocks;