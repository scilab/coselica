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
// Test MEAB_VariableResistor

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_VariableResistor.zcos"));
    xcos_simulate(scs_m, 4);

    V = res.values(:,1);
    R = res.values(:,2);
    I = res.values(:,3);

    assert_checkalmostequal(I, V./R);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
