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
sources_blocks = ["MTH_FixedTemperature"
                  "MTH_PrescribedTemperatur"
                  "MTH_FixedHeatFlow"
                  "MTH_PrescribedHeatFlow"
                 ];
components_blocks = ["MTH_HeatCapacitor"
                    "MTH_ThermalConductor"
                    "MTH_Convection"
                    "MTH_BodyRadiation"
                    ];
celsius_blocks = ["MTHC_ToKelvin"
                  "MTHC_FromKelvin"
                  "MTHC_FixedTemperature"
                  "MTHC_PrescribedTemperatu"
                  "MTHC_TemperatureSensor"
                 ];
sensors_blocks = ["MTH_TemperatureSensor"
                  "MTH_RelTemperatureSensor"
                  "MTH_HeatFlowSensor"
                 ];
blocks = [sources_blocks
          components_blocks
          celsius_blocks
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