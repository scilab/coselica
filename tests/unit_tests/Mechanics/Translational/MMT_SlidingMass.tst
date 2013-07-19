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
// Test MMT_SlidingMass

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/MMT_SlidingMass.zcos"));
    xcos_simulate(scs_m, 4);

    force = res.values(:,1);
    accel = res.values(:,2);
    m=2;

    assert_checktrue(abs(force - m*accel) <1d-8);

catch
    disp(lasterror())
    assert_checktrue(%f);
end
