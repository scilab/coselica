toolboxname = 'cos_blocks_nonlin';
nonlinear_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + nonlinear_pathB);
genlib(toolboxname + 'lib', nonlinear_pathB, %t);

clear nonlinear_pathB toolboxname
