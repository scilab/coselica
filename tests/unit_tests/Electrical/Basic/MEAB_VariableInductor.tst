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
// Test MEAB_VariableInductor

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_VariableInductor.zcos"));
    xcos_simulate(scs_m, 4);

    U = res.values(:,1);
    dI = res.values(:,2);
    L = res.values(:,3);

    assert_checktrue(abs(U - L.*dI) < 1d-4);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
