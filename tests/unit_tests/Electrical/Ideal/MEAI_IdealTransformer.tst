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
// Test MEAI_IdealTransformer

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "../../tests/unit_tests/Electrical/Ideal/MEAI_IdealTransformer.zcos"));
    xcos_simulate(scs_m, 4);

    Ve = res.values(:,2);
    Vs = res.values(:,1);

    assert_checkequal(Vs, 1/2*Ve);

catch
   disp(lasterror())
   assert_checktrue(%f);
end
