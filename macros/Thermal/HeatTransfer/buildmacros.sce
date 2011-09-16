// This file is released under the 3-clause BSD license. See COPYING-BSD.

function buildmacros()
  macros_path = get_absolute_file_path("buildmacros.sce");
  tbx_build_macros(TOOLBOX_NAME+"_TH_", macros_path);
endfunction

function buildblocks()
  macros_path = get_absolute_file_path("buildmacros.sce");
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
  tbx_build_blocks(toolbox_dir, blocks, macros_path);
  tbx_build_pal(toolbox_dir, "Sources", "CoselicaHeatTransfertSources.xpal", sources_blocks)
  tbx_build_pal(toolbox_dir, "Components", "CoselicaHeatTransfertComponents.xpal", components_blocks)
  tbx_build_pal(toolbox_dir, "Celsius", "CoselicaHeatTransfertCelsius.xpal", celsius_blocks)
  tbx_build_pal(toolbox_dir, "Sensors", "CoselicaHeatTransfertSensors.xpal", sensors_blocks)
endfunction

buildmacros();
// Need to load also Blocks/Interfaces
getd(toolbox_dir + filesep() + "macros" + filesep() + "Blocks" + filesep() + "Interfaces")
getd(get_absolute_file_path("buildmacros.sce"));
buildblocks();
clear buildmacros; // remove buildmacros on stack