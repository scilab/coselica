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
// Test MEAB_Gyrator

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_Gyrator.zcos"));
    xcos_simulate(scs_m, 4);

    i1 = res.values(:,1);
    V1 = res.values(:,2);
    V2 = res.values(:,3);
    i2 = res.values(:,4);
    G1 = 3;
    G2 = 0.5;

    assert_checkalmostequal(i1, G2*V2);
    assert_checkalmostequal(i2, -G1*V1);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
