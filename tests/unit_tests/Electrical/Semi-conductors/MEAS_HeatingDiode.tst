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
// Test MEAS_HeatingDiode

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Semi-conductors/MEAS_HeatingDiode.zcos"));
    xcos_simulate(scs_m, 4);
    
    Q = res.values(:,1);
    I = res.values(:,2);
    V = res.values(:,3);

    assert_checktrue(abs(Q-V.*I) < 9d-5);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
