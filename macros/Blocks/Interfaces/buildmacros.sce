toolboxname = 'cos_blocks_interf';
interfaces_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + interfaces_pathB);
genlib(toolboxname + 'lib', interfaces_pathB, %t);

clear interfaces_pathB toolboxname
