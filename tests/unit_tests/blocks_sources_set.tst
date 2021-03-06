// ============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- ENGLISH IMPOSED -->
//
// <-- Short Description -->
// Blocks must have valid dimensions for their settings.
// Some dimensions were not coherents between theirs "set" and "define" method.
blocks = ["CBS_Trapezoid"
          "MBS_Clock"
          "MBS_Constant"
          "MBS_ExpSine"
          "MBS_Exponentials"
          "MBS_Pulse"
          "MBS_Ramp"
          "MBS_SawTooth"
          "MBS_Sine"
          "MBS_Step"];
notTested = [];

funcprot(0);
needcompile = 0;
alreadyran = %f;
%scicos_context = struct();

for j = 1:size(blocks,"*")
    interfunction = blocks(j);

// Not tested blocks (Xcos customs)
    if or(interfunction == notTested) then
        continue;
    end
    [status, message] = xcosValidateBlockSet(blocks(j));
    if status == %f
        disp("Error on block "+blocks(j));
        disp(message);
    end
    assert_checktrue(status);
end
