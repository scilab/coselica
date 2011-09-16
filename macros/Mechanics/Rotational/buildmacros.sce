// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildmacros()
  macros_path = get_absolute_file_path("buildmacros.sce");
  tbx_build_macros(TOOLBOX_NAME+"_MR_", macros_path);
endfunction

function buildblocks()
  macros_path = get_absolute_file_path("buildmacros.sce");
  components_blocks = [ "MMR_Fixed"
                     "CMRC_Free"
                     "MMR_Inertia"
                     "CMRC_Disc"
                     "MMR_Spring"
                    "MMR_Damper"
                    "MMR_SpringDamper"
                    "CMRC_ElastoBacklash"
                    "CMR_BearingFriction"
                    "CMR_Brake"
                    "CMR_Clutch"
                    "CMR_OneWayClutch"
                    "CMR_Freewheel"
                    "MMR_IdealGear"
                    "MMR_IdealPlanetary"
                    "CMRC_IdealDifferential"
                    "MMR_IdealGearR2T"
                   ]
  sources_blocks = ["CMRS_Position0"
                    "CMRS_Speed0"
                    "CMRS_Accelerate0"
                    "CMRS_Torque0"
                    "CMRS_Position"
                    "CMRS_Speed"
                    "CMRS_Accelerate"
                    "CMRS_Torque"
                    "CMRS_Torque2"
                    "CMRS_ConstantTorque"
                    "CMRS_ConstantSpeed"
                    "CMRS_TorqueStep"
                    "CMRS_LinearSpeedDependen"
                    "CMRS_QuadraticSpeedDepen"
                   ]
  sensors_blocks = ["MMRS_AngleSensor"
                    "MMRS_SpeedSensor"
                    "MMRS_AccSensor"
                    "MMRS_RelAngleSensor"
                    "MMRS_RelSpeedSensor"
                    "MMRS_RelAccSensor"
                    "MMRS_TorqueSensor"
                    "CMRS_PowerSensor"
                   ]
  blocks = [sources_blocks
            components_blocks
            sensors_blocks
           ]
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
  tbx_build_pal(toolbox_dir, "Sources", "CoselicaMechanicsRotationalSources.xpal", sources_blocks)
  tbx_build_pal(toolbox_dir, "Components", "CoselicaMechanicsRotationalComponents.xpal", components_blocks)
  tbx_build_pal(toolbox_dir, "Sensors", "CoselicaMechanicsRotationalSensors.xpal", sensors_blocks)
endfunction

buildmacros();
getd(get_absolute_file_path("buildmacros.sce"));
buildblocks();
clear buildmacros; // remove buildmacros on stack
