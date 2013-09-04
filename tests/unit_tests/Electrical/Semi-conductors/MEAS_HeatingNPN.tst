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
// Test MEAS_HeatingNPN

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Semi-conductors/MEAS_HeatingNPN.zcos"));
    xcos_simulate(scs_m, 4);
    
    Vc = res.values(:,1);
    Ic = res.values(:,2);
    Ve = res.values(:,3);
    Ie = res.values(:,4);
    Q = res.values(:,5);
    Vb = res.values(:,6);
    Ib = res.values(:,7);

    assert_checktrue(abs(Q - (Ic.*Vc+Ib.*Vb+Ie.*Ve)) < 1d-9);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
