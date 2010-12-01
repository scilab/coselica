toolboxname = 'cos_blocks_srcs';
sources_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + sources_pathB);
genlib(toolboxname + 'lib', sources_pathB, %t);

clear sources_pathB toolboxname
