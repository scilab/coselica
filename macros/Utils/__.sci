//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013-2013 - Scilab Enterprises - Bruno JOFRET
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//

function trad = __(msg)
    //if getlanguage() <> "fr_FR" then
    //    trad = msg;
    //    return;
    //end

    en_US_msg = ["hello"]
    fr_FR_msg = ["bonjour"]
    index = find(en_US_msg == msg);
    if ~isempty(index) then
        trad = fr_FR_msg(index);
    else
        trad = msg
    end
endfunction