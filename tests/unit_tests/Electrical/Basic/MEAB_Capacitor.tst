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
// Test MEAB_Capacitor

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_Capacitor.zcos"));
    xcos_simulate(scs_m, 4);

    dvoltage = res.values(:,2);
    current = res.values(:,1);

    assert_checktrue(abs(current - (-2*dvoltage)) < 1e-4);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
