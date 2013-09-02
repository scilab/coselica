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
// Test CEAS_ZDiode

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Semi-conductors/CEAS_ZDiode.zcos"));
    xcos_simulate(scs_m, 4);
    
    Vd = res.values(:,1);
    Iout = res.values(:,2);
    Ids = 0.000001;
    Vt = 0.04;
    Maxexp = 30;
    R = 1.000d+08;
    Bv = 5.1;
    Ibv = 0.7;
    Nbv = 0.74;

    ind = find(Vd/Vt <= Maxexp & Vd + Bv >= -Maxexp*Nbv*Vt);
    assert_checktrue(Iout(ind) - (Ids * (exp(Vd(ind)/Vt) - 1) - Ibv * exp( -(Vd(ind) + Bv) / (Nbv * Vt)) + Vd(ind)/R) < 1d-5);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
