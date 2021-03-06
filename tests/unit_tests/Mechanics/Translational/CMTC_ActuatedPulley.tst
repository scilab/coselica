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
// Test CMTC_ActuatedPulley

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/CMTC_ActuatedPulley.zcos"));
    xcos_simulate(scs_m, 4);

    force_a = res.values(:,1);
    force_b1 = res.values(:,2);
    force_b2 = res.values(:,3);
    torque = res.values(:,4);
    R=2;
    force = torque/R;

    assert_checkequal(force_b2, force_b1+force);
    assert_checkequal(force_a, force_b1+force_b2);

catch
    disp(lasterror())
    assert_checktrue(%f);
end
