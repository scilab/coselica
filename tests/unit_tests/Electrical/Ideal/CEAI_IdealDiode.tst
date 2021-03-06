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
// Test CEAI_IdealDiode

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Ideal/CEAI_IdealDiode.zcos"));
    xcos_simulate(scs_m, 4);

    Vd = res.values(:,1);
    Vr = res.values(:,2);
    Vramp = res.values(:,3);
    Vknee = 0.5;
    
    ind = find(Vramp < Vknee);
    assert_checktrue(abs(Vr(ind) - zeros(ind)') < 1d-5);
    ind = find(Vramp >= Vknee);
    assert_checkalmostequal(Vramp(ind), Vr(ind)+Vd(ind));

catch
   disp(lasterror())
   assert_checktrue(%f);
end
