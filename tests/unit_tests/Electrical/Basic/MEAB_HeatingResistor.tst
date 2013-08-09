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
// Test MEAB_HeatingResistor

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_HeatingResistor.zcos"));
    xcos_simulate(scs_m, 4);

    voltage = res.values(:,1);
    current = res.values(:,2);
    heat_flow = res.values(:,3);

    assert_checkequal(-voltage, 2*current);
    assert_checkequal(heat_flow, -voltage.*current);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
