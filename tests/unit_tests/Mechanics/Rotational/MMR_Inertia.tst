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
// Test MMR_Inertia

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/MMR_Inertia.zcos"));
    xcos_simulate(scs_m, 4);

    acc = res.values(:,1);
    torque = res.values(:,2);

    assert_checktrue(torque - 2*acc < 1d-10);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
