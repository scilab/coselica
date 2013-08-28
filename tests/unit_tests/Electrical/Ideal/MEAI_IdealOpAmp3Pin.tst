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
// Test MEAI_IdealOpAmp3Pin

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Ideal/MEAI_IdealOpAmp3Pin.zcos"));
    xcos_simulate(scs_m, 4);
    
    q1 = res.values(:,1);
    V2 = res.values(:,2);
    q2 = res.values(:,3);
    V1 = res.values(:,4);
    R1 = 2;
    R2 = 3;

    assert_checkequal(q1, q2);
    assert_checkequal(V2, V1*(1+R2/R1));


catch
   disp(lasterror())
   assert_checktrue(%f);
end
