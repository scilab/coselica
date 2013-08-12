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
// Test CEAB_TranslationalEMF

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/CEAB_TranslationalEMF.zcos"));
    xcos_simulate(scs_m, 4);

    current = res.values(:,1);
    force1 = res.values(:,2);
    force2 = res.values(:,3);
    k = 2;

    assert_checkalmostequal(force1, K*current);
    assert_checkalmostequal(force2, -k*current);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
