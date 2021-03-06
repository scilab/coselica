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
// Test CMTC_ElastoGap

[a, coselicaMacrosPath] = libraryinfo(whereis(getCoselicaVersion));

try
    ilib_verbose(0);
    assert_checktrue(importXcosDiagram(coselicaMacrosPath + "/../../tests/unit_tests/Mechanics/Translational/CMTC_ElastoGap.zcos"));
    xcos_simulate(scs_m, 4);

    position = res.values(:,1);
    velocity = res.values(:,2);
    force = res.values(:,3);
    c=10;
    d=2;
    s_rel0 = 4;

    for i=1:99
        if position(i) > s_rel0 then
            fc(i) = 0;
            fd(i) = 0;
            fd2(i) = 0;
        else
            fc(i) = c * (position(i) - s_rel0);
            fd2(i) = d * velocity(i);
            if fd2(i) < fc(i) then
                fd(i) = fc(i);
            elseif fd2(i) > -fc(i) then
                fd(i) = -fc(i);
            else
                fd(i) = fd2(i);
            end
        end
    end
    f = fc + fd;
    assert_checkalmostequal(f, force);

catch
    disp(lasterror())
    assert_checktrue(%f);
end
