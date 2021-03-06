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
// Test CMTC_MassWithWeight

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/CMTC_MassWithWeight.zcos"));
    xcos_simulate(scs_m, 4);

    force = res.values(:,1);
    accel = res.values(:,2);
    mass = 2;
    g = 9.80665;

    assert_checktrue(force + mass*g - mass*accel < 1d-11);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
