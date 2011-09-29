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
sources_blocks = ["CMP_World"
                 ];
forces_blocks = ["CMPF_WorldForce"
                 "CMPF_WorldTorque"
                 "CMPF_FrameForce"
                 "CMPF_LineForce"
                 "CMPF_LineForceWithMass"
                ];
joints_blocks = ["CMPJ_FreeMotion"
                 "CMPJ_Prismatic"
                 "CMPJ_Revolute"
                 "CMPJ_ActuatedRevolute"
                 "CMPJ_RollingWheel"
                 "CMPJ_ActuatedRollingWhee"
                ];
loopjoints_blocks = ["CMPL_Prismatic"
                    "CMPL_Revolute"
                    "CMPL_ActuatedPrismatic"
                    "CMPL_ActuatedRevolute"
                    ];
parts_blocks = ["CMPP_Fixed"
                "CMPP_FixedTranslation"
                "CMPP_FixedRotation"
                "CMPP_Body"
                "CMPP_BodyShape"
                "CMPP_PointMass"
               ];
absolutesensors_blocks = [ "CMPS_AbsPosition"
                    "CMPS_AbsVelocity"
                    "CMPS_AbsAcceleration"
                    "CMPS_AbsAngle"
                    "CMPS_AbsAngularVelocity"
                    "CMPS_AbsAngularAccelerat"
                    "CMPS_AbsPosition2"
                    "CMPS_AbsVelocity2"
                    "CMPS_AbsAcceleration2"
                   ];
relativesensors_blocks = ["CMPS_Distance"
                    "CMPS_CutForce"
                    "CMPS_CutForce2"
                    "CMPS_CutTorque"
                    "CMPS_Power"
                    "CMPS_RelPosition"
                    "CMPS_RelVelocity"
                    "CMPS_RelAcceleration"
                    "CMPS_Angle"
                    "CMPS_RelAngularVelocity"
                    "CMPS_RelAngularAccelerat"
                    "CMPS_RelPosition2"
                    "CMPS_RelVelocity2"
                    "CMPS_RelAcceleration2"
                   ];
blocks = [sources_blocks
          forces_blocks
          joints_blocks
          loopjoints_blocks
          parts_blocks
          absolutesensors_blocks
          relativesensors_blocks
         ];
notTested = [];

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