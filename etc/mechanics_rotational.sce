// This file is released under the 3-clause BSD license. See COPYING-BSD.

toolbox_dir = get_absolute_file_path("mechanics_rotational.sce") + "..";
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
xpal = tbx_build_pal(toolbox_dir, "Sources", sources_blocks)
xcosPalAdd(xpal, ['Coselica', "Mechanics", "Rotational"]);
xpal = tbx_build_pal(toolbox_dir, "Components", components_blocks)
xcosPalAdd(xpal, ['Coselica', "Mechanics", "Rotational"]);
xpal = tbx_build_pal(toolbox_dir, "Sensors", sensors_blocks)
xcosPalAdd(xpal, ['Coselica', "Mechanics", "Rotational"]);
