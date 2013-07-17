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
// Test MMT_Rod

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/MMT_Rod.zcos"));
    xcos_simulate(scs_m, 4);

    position_in = res.values(:,1);
    position_out = res.values(:,2);

    assert_checkequal(position_out, position_in);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
