// This file is released under the 3-clause BSD license. See COPYING-BSD.

function runMe()
    toolbox_dir = get_absolute_file_path("mechanics_translational.sce") + "..";
    sources_blocks = ["CMTS_ImposedKinematic"
                      "CMTS_Position0"
                      "CMTS_Speed0"
                      "CMTS_Accelerate0"
                      "CMTS_Force0"
                      "CMTS_Position"
                      "CMTS_Speed"
                      "CMTS_Accelerate"
                      "CMTS_Force"
                      "CMTS_Force2"
                      "CMTS_ConstantForce"
                      "CMTS_ConstantSpeed"
                      "CMTS_ForceStep"
                      "CMTS_LinearSpeedDependen"
                      "CMTS_QuadraticSpeedDepen"
                     ]
    components_blocks = ["MMT_Fixed"
                    "CMTC_Free"
                    "CMTC_Mass"
                    "CMTC_MassWithWeight"
                    "MMT_Rod"
                    "MMT_Spring"
                    "MMT_Damper"
                    "MMT_SpringDamper"
                    "CMTC_ElastoGap"
                    "CMT_MassWithFriction"
                    "MMT_SlidingMass"
                    "CMT_Stop"
                    "CMTC_Pulley"
                    "CMTC_ActuatedPulley"
                    "CMTC_Lever"
                        ]
    sensors_blocks = ["CMTS_PositionSensor"
                      "CMTS_SpeedSensor"
                      "CMTS_AccSensor"
                      "CMTS_RelPositionSensor"
                      "CMTS_RelSpeedSensor"
                      "CMTS_RelAccSensor"
                      "CMTS_ForceSensor"
                      "CMTS_PowerSensor"
                      "CMTS_GenSensor"
                      "CMTS_GenRelSensor"
                     ]
    xpal = tbx_build_pal(toolbox_dir, "Sources", sources_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Translational"]);
    xpal = tbx_build_pal(toolbox_dir, "Components", components_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Translational"]);
    xpal = tbx_build_pal(toolbox_dir, "Sensors", sensors_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Translational"]);

endfunction

runMe();
clear runMe;