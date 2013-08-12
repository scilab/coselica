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
// Test CEAB_TranslationalEMF0

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/CEAB_TranslationalEMF0.zcos"));
    xcos_simulate(scs_m, 4);

    current = res.values(:,1);
    force = res.values(:,2);
    K = 2;

    assert_checkalmostequal(force, Kc*current);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
