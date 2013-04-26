// ============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- ENGLISH IMPOSED -->
//
// <-- Short Description -->
// Blocks must have valid dimensions for their settings.
// Some dimensions were not coherents between theirs "set" and "define" method.
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
                    ];
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
                 ];
sensors_blocks = ["MMRS_AngleSensor"
                  "MMRS_SpeedSensor"
                  "MMRS_AccSensor"
                  "MMRS_RelAngleSensor"
                  "MMRS_RelSpeedSensor"
                  "MMRS_RelAccSensor"
                  "MMRS_TorqueSensor"
                  "CMRS_PowerSensor"
                 ];
blocks = [sources_blocks
          components_blocks
          sensors_blocks
         ];
notTested = [];

funcprot(0);
needcompile = 0;
alreadyran = %f;
%scicos_context = struct();

for j = 1:size(blocks,"*")
    interfunction = blocks(j);

// Not tested blocks (Xcos customs)
    if or(interfunction == notTested) then
        continue;
    end
    [status, message] = xcosValidateBlockSet(blocks(j));
    if status == %f
        disp("Error on block "+blocks(j));
        disp(message);
    end
    assert_checktrue(status);
end