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
// Test CMTC_Lever

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/CMTC_Lever.zcos"));
    xcos_simulate(scs_m, 4);

    force_a = res.values(:,1);
    force_b1 = res.values(:,2);
    force_b2 = res.values(:,3);
    L1=2;
    L2=1;

    assert_checkequal(force_a*L1-force_b2*(L1+L2), 0);
    assert_checkequal(force_a*L2-force_b1*(L1+L2), 0);

catch
    disp(lasterror())
    assert_checktrue(%f);
end
