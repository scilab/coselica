// This file is released under the 3-clause BSD license. See COPYING-BSD.

function runMe()
    sources_blocks = ["MTH_FixedTemperature"
                      "MTHC_FixedTemperature"
                      "MTH_PrescribedTemperatur"
                      "MTHC_PrescribedTemperatu"
                      "MTH_FixedHeatFlow"
                      "MTH_PrescribedHeatFlow"
                     ]
    components_blocks = ["MTH_HeatCapacitor"
                    "MTH_ThermalConductor"
                    "MTH_Convection"
                    "MTH_BodyRadiation"
                        ]
    celsius_blocks = ["MTHC_ToKelvin"
                      "MTHC_FromKelvin"
                     ]
    sensors_blocks = ["MTH_TemperatureSensor"
                      "MTHC_TemperatureSensor"
                      "MTH_RelTemperatureSensor"
                      "MTH_HeatFlowSensor"
                     ]
    blocks = [sources_blocks
              components_blocks
              celsius_blocks
              sensors_blocks
             ]
    toolbox_dir = get_absolute_file_path("thermal_heattransfer.sce")+".."
    xpal = tbx_build_pal(toolbox_dir, "Sources", sources_blocks)
    xcosPalAdd(xpal, ['Coselica', "Heat Transfer"]);
    xpal = tbx_build_pal(toolbox_dir, "Components", components_blocks)
    xcosPalAdd(xpal, ['Coselica', "Heat Transfer"]);
    xpal = tbx_build_pal(toolbox_dir, "Conversion", celsius_blocks)
    xcosPalAdd(xpal, ['Coselica', "Heat Transfer"]);
    xpal = tbx_build_pal(toolbox_dir, "Sensors", sensors_blocks)
    xcosPalAdd(xpal, ['Coselica', "Heat Transfer"]);

endfunction

runMe();
clear runMe;
