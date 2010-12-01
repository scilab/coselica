toolboxname = 'cos_blocks_math';
math_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + math_pathB);
genlib(toolboxname + 'lib', math_pathB, %t);

clear math_pathB toolboxname
