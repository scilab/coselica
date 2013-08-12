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
// Test CEAB_EMF0

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/CEAB_EMF0.zcos"));
    xcos_simulate(scs_m, 4);

    current = res.values(:,1);
    torque = res.values(:,2);
    Kc = 2;

    assert_checkalmostequal(torque, Kc*current);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
