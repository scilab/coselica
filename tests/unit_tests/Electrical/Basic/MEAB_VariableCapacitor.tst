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
// Test MEAB_VariableCapacitor

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_VariableCapacitor.zcos"));
    xcos_simulate(scs_m, 4);

    C = res.values(:,1);
    dUc = res.values(:,2);
    I = res.values(:,3);

    assert_checktrue(abs(I - C.*dUc) < 1d-10);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
