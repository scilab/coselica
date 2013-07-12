// ============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- ENGLISH IMPOSED -->
//
// <-- Short Description -->
// Test CMRC_ElastoBacklash

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/CMRC_ElastoBacklash.zcos"));
    xcos_simulate(scs_m, 4);

    torque = res.values(:,1);
    position = res.values(:,2);
    speed = res.values(:,3);
    position_new = position;
    
    for i=1:99
        if (position(i) > 0.001) then
            position_new(i) = position(i) - 0.001/2;
        else
            position_new(i) = position(i);
        end
    end

    assert_checkalmostequal(torque, 2*position_new+10*speed);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
