// This file is released under the 3-clause BSD license. See COPYING-BSD.

sources_blocks = ["MTH_FixedTemperature"
                  "MTH_PrescribedTemperatur"
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
                  "MTHC_FixedTemperature"
                  "MTHC_PrescribedTemperatu"
                  "MTHC_TemperatureSensor"
                 ]
sensors_blocks = ["MTH_TemperatureSensor"
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
xpal = tbx_build_pal(toolbox_dir, "Components", sources_blocks)
xcosPalAdd(xpal, ['Coselica', "Heat Transfer"]);
xpal = tbx_build_pal(toolbox_dir, "Celsius", celsius_blocks)
xcosPalAdd(xpal, ['Coselica', "Heat Transfer"]);
xpal = tbx_build_pal(toolbox_dir, "Sensors", sensors_blocks)
xcosPalAdd(xpal, ['Coselica', "Heat Transfer"]);
