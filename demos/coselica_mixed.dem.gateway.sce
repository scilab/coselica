//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015- Scilab Enterprises - Paul Bignier
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//

function subdemolist = demo_gateway()
    demopath = get_absolute_file_path("coselica_mixed.dem.gateway.sce");

    subdemolist = ["Driven CC motor"            , "DrivenCCMotor.dem.sce"
    "Current-controlled motor"   , "CurrentControlledMotor.dem.sce"
    ];

    subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction

subdemolist = demo_gateway();
clear demo_gateway; // remove demo_gateway on stack
