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
// Test CMTC_MassWithFriction

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/CMTC_MassWithFriction.zcos"));
    xcos_simulate(scs_m, 4);

    force = res.values(:,1);
    accel = res.values(:,2);
    velocity = res.values(:,3);
    position = res.values(:,4);
    m=2;
    F_prop=1;
    F_Coulomb=1;
    F_Stribeck=5;
    fexp=0.1;

    f1 = F_prop * velocity + F_Coulomb + F_Stribeck * exp( -fexp * velocity)

    assert_checktrue(f1-force+m*accel <1d-5);

catch
    disp(lasterror())
    assert_checktrue(%f);
end
