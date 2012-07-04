// This file is released under the 3-clause BSD license. See COPYING-BSD.
function runMe()
    toolbox_dir = get_absolute_file_path("mechanics_planar.sce") + "..";
    sources_blocks = ["CMP_World"
                     ]
    forces_blocks = ["CMPF_WorldForce"
                     "CMPF_WorldTorque"
                     "CMPF_FrameForce"
                     "CMPF_LineForce"
                     "CMPF_LineForceWithMass"
                    ]
    joints_blocks = ["CMPJ_FreeMotion"
                     "CMPJ_Prismatic"
                     "CMPJ_Revolute"
                     "CMPJ_ActuatedRevolute"
                     "CMPJ_RollingWheel"
                     "CMPJ_ActuatedRollingWhee"
                     "CMPJ_ActuatedPrismatic"
                    ]
    loopjoints_blocks = ["CMPL_Prismatic"
                    "CMPL_Revolute"
                    "CMPL_ActuatedPrismatic"
                    "CMPL_ActuatedRevolute"
                        ]
    parts_blocks = ["CMPP_Fixed"
                    "CMPP_FixedTranslation"
                    "CMPP_FixedRotation"
                    "CMPP_Body"
                    "CMPP_BodyShape"
                    "CMPP_PointMass"
                   ]
    absolutesensors_blocks = [ "CMPS_AbsPosition"
                    "CMPS_AbsVelocity"
                    "CMPS_AbsAcceleration"
                    "CMPS_AbsAngle"
                    "CMPS_AbsAngularVelocity"
                    "CMPS_AbsAngularAccelerat"
                    "CMPS_AbsPosition2"
                    "CMPS_AbsVelocity2"
                    "CMPS_AbsAcceleration2"
                   ]
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
                   ]

    xpal = tbx_build_pal(toolbox_dir, "Sources", sources_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Planar"]);
    xpal = tbx_build_pal(toolbox_dir, "Forces", forces_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Planar"]);
    xpal = tbx_build_pal(toolbox_dir, "Joints", joints_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Planar"]);
    xpal = tbx_build_pal(toolbox_dir, "Loop Joints", loopjoints_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Planar"]);
    xpal = tbx_build_pal(toolbox_dir, "Parts", parts_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Planar"]);
    xpal = tbx_build_pal(toolbox_dir, "Absolute Sensors", absolutesensors_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Planar"]);
    xpal = tbx_build_pal(toolbox_dir, "Relative Sensors", relativesensors_blocks)
    xcosPalAdd(xpal, ['Coselica', "Mechanics", "Planar"]);

endfunction

runMe()
clear runMe;