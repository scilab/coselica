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
// Test MEAB_Inductor

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_Inductor.zcos"));
    xcos_simulate(scs_m, 4);

    current = res.values(:,1);
    dcurrent = res.values(:,2);
    voltage = res.values(:,3);

    assert_checktrue(abs(voltage - (2*dcurrent+1*current)) < 1e-5);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
