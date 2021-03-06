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
                    "MEAB_SaturatingInductor"
                    "MEAB_Transformer"
                    "MEAB_Gyrator"
                    "CEAB_EMFGEN"
                    "CEAB_EMF0"
                    "CEAB_EMF"
                    "CEAB_TranslationalEMFGEN"
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
                    "MEAI_IdealCommutSwitch"
                    "MEAI_IdealOpAmp"
                    "MEAI_IdealOpAmp3Pin"
                    "MEAI_IdealOpAmpLimited"
                    "MEAI_CloserWithArc"
                   ]
    semiconductors_blocks = ["MEAS_Diode"
                    "CEAS_ZDiode"
                    "MEAS_PMOS"
                    "MEAS_NMOS"
                    "MEAS_NPN"
                    "MEAS_PNP"
                    "CEAS_Thyristor"
                    "MEAS_HeatingDiode"
                    "MEAS_HeatingPMOS"
                    "MEAS_HeatingNMOS"
                    "MEAS_HeatingNPN"
                    "MEAS_HeatingPNP"
                   ]
    sensors_blocks = ["MEAS_PotentialSensor"
                      "MEAS_VoltageSensor"
                      "MEAS_CurrentSensor"
                      "CEAS_PowerSensor"
                     ]
   machines_blocks = ["MEMC_PartialAirGapDC"
                      "MEMC_PartialAirGap"
                      "MEMC_AirGapDC"
                      "MEMC_AirGapR"
                      "MEMC_AirGapS"
                      "MEMC_DamperCage"
                      "MEMC_SquirrelCage"
                      "MEMC_PermanentMagnet"
                      "MEMC_ElectricExcitation"
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
//    xpal = tbx_build_pal(toolbox_dir, "Machines", machines_blocks)
//    xcosPalAdd(xpal, ["Coselica", "Electrical"]);

endfunction

runMe();
clear runMe;