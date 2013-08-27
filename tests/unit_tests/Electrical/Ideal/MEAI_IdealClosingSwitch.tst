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
// Test MEAI_IdealClosingSwitch

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Ideal/MEAI_IdealClosingSwitch.zcos"));
    xcos_simulate(scs_m, 4);
    
    V = res.values(:,1);
    I = res.values(:,2);
    cmd = res.values(:,3);
    R = 0.5;
    Ron = 0.00001;
    Goff = 0.00001;

    ind = find(cmd>0);
    assert_checkalmostequal(I(ind), V(ind)/(R+Ron));
    ind = find(cmd==0);
    ind = ind(2:$);
    assert_checktrue(I(ind) - V(ind)*Goff < 1d-9);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
