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
    if getlanguage() <> "fr_FR" then
        trad = _(msg);
        return;
    end

    global %coselicaMessages;
    if isempty(%coselicaMessages)
        thisLib = whereis("__");
        [macrolist, path] = libraryinfo(thisLib);
        %coselicaMessages = csvRead(path+strcat(["..", "..", "etc"]+filesep())+"messages.csv", "$$", [], "string")
    end

    index = find(%coselicaMessages(:, 1) == msg);
    if ~isempty(index) then
        index = index(1); // If multiple translations are available, take the first one.
        if isempty(%coselicaMessages(index, 3)) then
            trad = %coselicaMessages(index, 2);
        else
            trad = %coselicaMessages(index, 2:3)';
        end
    else
        trad = _(msg);
    end
endfunction
