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
// Test MEAB_OpAmp

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Basic/MEAB_OpAmp.zcos"));
    xcos_simulate(scs_m, 4);

    Vout = res.values(:,1);
    Vin = res.values(:,2);
    VMax = res.values(:,3);
    Slope = 2;

    assert_checkalmostequal(Vout, VMax/2+(Slope*Vin)/(1+Slope*2/VMax*Vin));

catch
   disp(lasterror())
   assert_checktrue(%f);
end
