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
// Test MEAS_PNP

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Semi-conductors/MEAS_PNP.zcos"));
    xcos_simulate(scs_m, 4);
    
    Vec = res.values(:,1);
    Ib = res.values(:,2);
    Valim = 12*ones(Vec);
    
    ind = find(Ib < 0);
    assert_checktrue(abs(Vec(ind)) < 1d-3);
    ind = find(Ib >= 0);
    assert_checkalmostequal(Vec(ind), Valim(ind));

catch
   disp(lasterror())
   assert_checktrue(%f);
end
