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
// Test MMR_Fixed

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/MMR_Fixed.zcos"));
    xcos_simulate(scs_m, 4);

    out = res.values(:,1);
    in = res.values(:,2);

    assert_checkequal(in, 2*ones(99,1));
    assert_checkequal(out, zeros(99,1));

catch
   disp(lasterror())
   assert_checktrue(%f);
end
