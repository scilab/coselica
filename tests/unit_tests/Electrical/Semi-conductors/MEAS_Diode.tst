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
// Test MEAS_Diode

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Ideal/MEAS_Diode.zcos"));
    xcos_simulate(scs_m, 4);
    
    Iout = res.values(:,1);
    Vin = res.values(:,2);
    Ids = 0.000001;
    Vt = 0.04;
    Maxexp = 15;
    R = 1.000d+08;

    ind = find(Vin/Vt > Maxexp);
    assert_checktrue(Iout(ind) - (Ids * (exp(Maxexp) * (1 + Vin(ind)/Vt - Maxexp) - 1) + Vin(ind)/R) < 1d-11);
    ind = find(Vin/Vt <= Maxexp);
    assert_checkalmostequal(Iout(ind), Ids * (exp(Vin(ind)/Vt) - 1) + Vin(ind)/R);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
