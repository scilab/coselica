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
// Test MMT_Spring

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/MMT_Spring.zcos"));
    xcos_simulate(scs_m, 4);

    position = res.values(:,1);
    force = res.values(:,2);
    c=5;

    assert_checkequal(force, c*position);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
