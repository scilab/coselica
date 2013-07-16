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
// Test MMT_Fixed

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/MMT_Fixed.zcos"));
    xcos_simulate(scs_m, 4);

    position = res.values(:,1);

    assert_checkequal(position, zeros(99,1));

catch
   disp(lasterror())
   assert_checktrue(%f);
end
