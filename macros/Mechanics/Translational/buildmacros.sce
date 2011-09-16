// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildmacros()
  macros_path = get_absolute_file_path("buildmacros.sce");
  tbx_build_macros(TOOLBOX_NAME+"_MT_", macros_path);
endfunction

function buildblocks()
  macros_path = get_absolute_file_path("buildmacros.sce");
  sources_blocks = ["CMTS_Position0"
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
                   ]
  blocks = [sources_blocks
            components_blocks
            sensors_blocks
           ]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
  tbx_build_pal(toolbox_dir, "Sources", "CoselicaMechanicsTranslationalSources.xpal", sources_blocks)
  tbx_build_pal(toolbox_dir, "Components", "CoselicaMechanicsTranslationalComponents.xpal", components_blocks)
  tbx_build_pal(toolbox_dir, "Sensors", "CoselicaMechanicsTranslationalSensors.xpal", sensors_blocks)
endfunction

buildmacros();
getd(get_absolute_file_path("buildmacros.sce"));
buildblocks();
clear buildmacros; // remove buildmacros on stack
