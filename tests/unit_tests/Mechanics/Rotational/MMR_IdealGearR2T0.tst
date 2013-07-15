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
// Test MMR_IdealGearR2T0

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/MMR_IdealGearR2T0.zcos"));
    xcos_simulate(scs_m, 4);

    in = res.values(:,2);
    out = res.values(:,1);

    assert_checktrue(abs(2*in - out) < 1d-7);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
