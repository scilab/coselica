// This file is released under the 3-clause BSD license. See COPYING-BSD.
function runMe()
    toolbox_dir = get_absolute_file_path("electrical.sce")+"..";

    sources_blocks = ["MEAS_SignalVoltage"
                      "MEAS_ConstantVoltage"
                      "MEAS_StepVoltage"
                      "MEAS_RampVoltage"
                      "MEAS_SineVoltage"
                      "MEAS_PulseVoltage"
                      "MEAS_SawToothVoltage"
                      "CEAS_TrapezoidVoltage"
                      "MEAS_SignalCurrent"
                      "MEAS_ConstantCurrent"
                      "MEAS_StepCurrent"
                      "MEAS_RampCurrent"
                      "MEAS_SineCurrent"
                      "MEAS_PulseCurrent"
                      "MEAS_SawToothCurrent"
                      "CEAS_TrapezoidCurrent"
                     ]
    basic_blocks = ["MEAB_Ground"
                    "MEAB_Resistor"
                    "MEAB_Conductor"
                    "MEAB_HeatingResistor"
                    "MEAB_Capacitor"
                    "MEAB_Inductor"
                    "MEAB_Transformer"
                    "MEAB_Gyrator"
                    "CEAB_EMF0"
                    "CEAB_EMF"
                    "CEAB_TranslationalEMF0"
                    "CEAB_TranslationalEMF"
                    "MEAB_VCV"
                    "MEAB_VCC"
                    "MEAB_CCV"
                    "MEAB_CCC"
                    "MEAB_OpAmp"
                    "MEAB_VariableResistor"
                    "MEAB_VariableConductor"                  
                    "MEAB_VariableCapacitor"
                    "MEAB_VariableInductor"
                   ]
    ideal_blocks = ["CEAI_IdealDiode"
                    "MEAI_IdealTransformer"
                    "MEAI_IdealGyrator"
                    "MEAI_Idle"
                    "MEAI_Short"
                    "MEAI_IdealOpeningSwitch"
                    "MEAI_IdealClosingSwitch"
                   ]
    semiconductors_blocks = ["MEAS_Diode"
                    "CEAS_ZDiode"
                    "MEAS_PMOS"
                    "MEAS_NMOS"
                    "MEAS_NPN"
                    "MEAS_PNP"
                    "CEAS_Thyristor"
                   ]
    sensors_blocks = ["MEAS_PotentialSensor"
                      "MEAS_VoltageSensor"
                      "MEAS_CurrentSensor"
                      "CEAS_PowerSensor"
                     ]
    xpal = tbx_build_pal(toolbox_dir, "Sources", sources_blocks)
    xcosPalAdd(xpal, ['Coselica', "Electrical"]);
    xpal = tbx_build_pal(toolbox_dir, "Basic", basic_blocks)
    xcosPalAdd(xpal, ['Coselica', "Electrical"]);
    xpal = tbx_build_pal(toolbox_dir, "Ideal", ideal_blocks)
    xcosPalAdd(xpal, ['Coselica', "Electrical"]);
    xpal = tbx_build_pal(toolbox_dir, "Semi-conductors", semiconductors_blocks)
    xcosPalAdd(xpal, ['Coselica', "Electrical"]);
    xpal = tbx_build_pal(toolbox_dir, "Sensors", sensors_blocks)
    xcosPalAdd(xpal, ['Coselica', "Electrical"]);

endfunction

runMe();
clear runMe;