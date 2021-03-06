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
// Test MEAB_Transformer

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_Transformer.zcos"));
    xcos_simulate(scs_m, 4);

    di1 = res.values(:,1);
    V1 = res.values(:,2);
    di2 = res.values(:,3);
    V2 = res.values(:,4);
    L1 = 1;
    L2 = 2;
    M = 1;

    assert_checktrue(abs(V1 - (L1*di1+M*di2)) < 1e-5);
    assert_checktrue(abs(V2 - (L2*di2+M*di1)) < 1e-5);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
