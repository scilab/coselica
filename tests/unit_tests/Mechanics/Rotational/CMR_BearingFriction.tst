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
// Test CMR_BearingFriction

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/CMR_BearingFriction.zcos"));
    xcos_simulate(scs_m, 4);

    torque = res.values(:,1);
    accel = res.values(:,2);
    velocity = res.values(:,3);
    position = res.values(:,4);
    J=20;
    Tau_prop=1;
    Tau_Coulomb=5;
    Tau_Stribeck=2;
    fexp=0.5;

    Tau1 = Tau_prop * velocity + Tau_Coulomb + Tau_Stribeck * exp( -fexp * velocity);

    assert_checktrue(abs(Tau1-torque+J*accel) <1d-5);

catch
    disp(lasterror())
    assert_checktrue(%f);
end
