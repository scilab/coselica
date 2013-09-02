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
// Test MEAS_NPN

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Semi-conductors/MEAS_NPN.zcos"));
    xcos_simulate(scs_m, 4);
    
    Vce = res.values(:,1);
    Ib = res.values(:,2);
    Ie = res.values(:,3);
    Valim = 12*ones(Vce);
    Rd = 10000;

    ind = find(Ib <= 0);
    assert_checktrue(abs(Valim(ind) - Vce(ind)) < 1d-5);
    ind = find(Ib > 0);
    assert_checktrue(abs(Ib(ind) - Ie(ind)) < 2d-3);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
