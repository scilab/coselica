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
// Test MMR_IdealPlanetary

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/MMR_IdealPlanetary.zcos"));
    xcos_simulate(scs_m, 4);

    sun_vel = res.values(:,1);
    carrier_vel = res.values(:,2);
    ring_vel = res.values(:,3);

    assert_checkalmostequal(ring_vel, carrier_vel - (sun_vel - carrier_vel)/2);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
