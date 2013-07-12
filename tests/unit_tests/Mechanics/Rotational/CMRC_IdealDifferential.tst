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
// Test CMRC_IdealDifferential

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/CMRC_IdealDifferential.zcos"));
    xcos_simulate(scs_m, 4);

    drive_shaft = res.values(:,1);
    left_wheel = res.values(:,2);
    right_wheel = res.values(:,3);

    assert_checkalmostequal(drive_shaft, 3*(left_wheel+right_wheel)/2);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
