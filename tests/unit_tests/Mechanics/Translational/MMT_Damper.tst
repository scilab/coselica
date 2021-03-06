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
// Test MMT_Damper

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/MMT_Damper.zcos"));
    xcos_simulate(scs_m, 4);

    velocity = res.values(:,1);
    force = res.values(:,2);
    d=2;

    assert_checktrue(force - d*velocity < 1d-7);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
