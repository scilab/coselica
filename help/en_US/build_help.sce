// This file is released under the 3-clause BSD license. See COPYING-BSD.

// overload of the dialogs
prot=funcprot();
funcprot(0)
previous = messagebox;
function [btn] = messagebox(msg, msgboxtitle, msgboxicon, buttons, ismodal)
  disp(msg);
  btn = 0;
endfunction
funcprot(prot)

tbx_build_help(TOOLBOX_TITLE,get_absolute_file_path("build_help.sce"));

prot=funcprot();
funcprot(0)
messagebox = previous;
funcprot(prot)

