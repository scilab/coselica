// This file is released under the 3-clause BSD license. See COPYING-BSD.
function runMe()
    toolbox_dir = get_absolute_file_path("components.sce")+"..";

    actuators_blocks = [ 
                    "MEMC_DCmotor"
                     ]
                     
    preactuators_blocks = [  
                      "MEMC_Q4driver"
                      "MEMC_Q1driver"
                      "CCP_PWM"
                     ]
     
    setlanguage('en');
    xpal = tbx_build_pal(toolbox_dir, "Actuators", actuators_blocks)
    xcosPalAdd(xpal, ['Coselica', 'Components']);
    xpal = tbx_build_pal(toolbox_dir, "PreActuators", preactuators_blocks)
    xcosPalAdd(xpal, ['Coselica', 'Components']);
    
endfunction

runMe();
clear runMe;
