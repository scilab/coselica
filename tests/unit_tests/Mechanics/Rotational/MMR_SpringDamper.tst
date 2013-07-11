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
// Test MMR_SpringDamper

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Rotational/MMR_SpringDamper.zcos"));
    xcos_simulate(scs_m, 4);

    torque = res.values(:,1);
    position = res.values(:,2);
    speed = res.values(:,3);

    assert_checkalmostequal(torque, 2*position+10*speed);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
