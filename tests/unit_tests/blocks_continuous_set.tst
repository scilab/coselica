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
blocks = ["CBC_StateSpace"
          "CBC_TransferFunction"
          "MBC_Der"
          "MBC_Derivative"
          "MBC_FirstOrder"
          "MBC_Integrator"
          "MBC_LimIntegrator"
          "MBC_LimPID"
          "MBC_PI"
          "MBC_PID"
          "MBC_SecondOrder"];

notTested = [];

for j = 1:size(blocks,"*")
    interfunction = blocks(j);

// Not tested blocks (Xcos customs)
    if or(interfunction == notTested) then
        continue;
    end
    [status, message] = xcosValidateBlockSet(blocks(j));
    if status == %f
        disp(message);
    end
    assert_checktrue(status);
end