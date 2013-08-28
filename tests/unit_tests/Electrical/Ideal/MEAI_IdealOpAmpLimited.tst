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
// Test MEAI_IdealOpAmpLimited

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Ideal/MEAI_IdealOpAmpLimited.zcos"));
    xcos_simulate(scs_m, 4);
    
    Vs = res.values(:,1);
    Vmax = res.values(:,2);
    Ve = res.values(:,3);
    R1 = 2;
    R2 = 3;

    ind = find(Vs < Vmax-1d-15);
    assert_checkalmostequal(Vs(ind), Ve(ind)*(1+R2/R1));
    ind = find(Vs>= Vmax);
    assert_checkalmostequal(Vs(ind), Vmax(ind));


catch
   disp(lasterror())
   assert_checktrue(%f);
end
