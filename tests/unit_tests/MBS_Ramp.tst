// ============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- ENGLISH IMPOSED -->
//
// <-- Short Description -->
// Test MBS_Ramp output

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/MBS_Ramp.zcos"));
    xcos_simulate(scs_m, 4);

    values = res.values;

    assert_checkequal(res.values(1:100), zeros(100,1));
    assert_checkalmostequal(res.values(101:251), linspace(0,10,151)');
    assert_checkequal(res.values(251:300), 10*ones(50,1));

catch
   disp(lasterror())
   assert_checktrue(%f);
end