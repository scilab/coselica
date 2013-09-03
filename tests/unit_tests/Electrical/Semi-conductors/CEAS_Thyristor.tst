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
// Test CEAS_Thyristor

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Semi-conductors/CEAS_Thyristor.zcos"));
    xcos_simulate(scs_m, 4);
    
    Vac = res.values(:,1);
    Ic = res.values(:,2);
    Vr = res.values(:,3);
    Ig = res.values(:,4);
    Ve = res.values(:,5);
    R = 1000;
    VDRM = 100;
    VTM = 1.7;
    IH = 0.006;
    Roff = VDRM*VDRM/(VTM*IH);
    VTM = 1.7;
    ITM = 25;
    Ron = (VTM-0.7)/ITM;

    ind = find(Ig <= 0.001);
    assert_checktrue(abs(Vac(ind) - Roff*Ic(ind)) < 1d-6)
    assert_checktrue(abs(Ve(ind) - Vac(ind)) < 2d-2);
    ind = find(Ig > 0.001);
    assert_checktrue(abs(Vac(ind) - Ron*Ig(ind)) < 2d-3);
    assert_checktrue(abs(Ve(ind) - Vr(ind)) < 5d-1);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
