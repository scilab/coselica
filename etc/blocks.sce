// This file is released under the 3-clause BSD license. See COPYING-BSD.
function runMe()
    toolbox_dir = get_absolute_file_path("blocks.sce")+".."
// Sources
    blocks = ["MBS_Constant"
              "MBS_Step"
              "MBS_Ramp"
              "MBS_Sine"
              "MBS_Pulse"
              "CBS_Trapezoid"
              "MBS_ExpSine"
              "MBS_Exponentials"
              "MBS_SawTooth"
              "MBS_Clock"
             ]

    xpal = tbx_build_pal(toolbox_dir, "Sources", blocks)
    xcosPalAdd(xpal, ['Coselica', "Blocks"]);

// Continuous
    blocks = ["MBC_Integrator"
              "MBC_Der"
              "MBC_FirstOrder"
              "MBC_SecondOrder"
              "CBC_TransferFunction"
              "MBC_PI"
              "MBC_Derivative"
              "MBC_PID"
              "MBC_LimIntegrator"
              "MBC_LimPID"
              "CBC_StateSpace"
             ]

    xpal = tbx_build_pal(toolbox_dir, "Continuous", blocks);
    xcosPalAdd(xpal, ['Coselica', "Blocks"]);

// Non Linear
    blocks = ["CBN_Hysteresis"
              "CBN_RateLimiter"
              "MBN_DeadZone"
              "MBN_Limiter"
             ]

    xpal = tbx_build_pal(toolbox_dir, "Nonlinear", blocks);
    xcosPalAdd(xpal, ['Coselica', "Blocks"]);

    //Interfaces
    blocks = ["CBI_RealInput"
              "CBI_RealOutput"
             ]

    xpal = tbx_build_pal(toolbox_dir, "Interfaces", blocks);
    xcosPalAdd(xpal, ['Coselica', "Blocks"]);

    //Math
    blocks = [ "MBM_Abs"
               "MBM_Acos"
               "MBM_Add"
               "CBM_Add3"
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
               "MBM_Tanh"
               "CBM_Atan2"
               "CBM_Sum"
               "CBM_TwoInputs"
               "CBM_TwoOutputs"
               "CBMV_Add"
               "CBMV_CrossProduct"
               "CBMV_DotProduct"
               "CBMV_ElementwiseProduct"
             ]

    xpal = tbx_build_pal(toolbox_dir, "Math", blocks);
    xcosPalAdd(xpal, ['Coselica', "Blocks"]);

// Routing
    blocks = ["CBR_DeMultiplex2"
              "CBR_DeMultiplexVector2"
              "CBR_Extractor"
              "CBR_Multiplex2"
              "CBR_MultiplexVector2"
              "CBR_Replicator"]

    xpal = tbx_build_pal(toolbox_dir, "Routing", blocks);
    xcosPalAdd(xpal, ['Coselica', "Blocks"]);
endfunction

runMe();
clear runMe;