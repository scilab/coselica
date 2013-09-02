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
// Test MEAS_PMOS

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Semi-conductors/MEAS_PMOS.zcos"));
    xcos_simulate(scs_m, 4);
    
    Vds = res.values(:,1);
    Id = res.values(:,2);
    Vgs = res.values(:,3);
    Valim = 12*ones(Vds);
    Rds = 1e7;
    Rd = 10000;

    ind = find(Vgs <= 0);
    assert_checktrue(abs(Valim(ind) - (Rd * Id(ind)) - Vds(ind)) < 1d-10);
    ind = find(Vgs > 0);
    assert_checktrue(abs(Vds(ind) - Valim(ind)) < 2d-2);
    assert_checktrue(abs(Id(ind)) < 1d-5);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
