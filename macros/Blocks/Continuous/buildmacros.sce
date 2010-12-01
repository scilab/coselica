toolboxname = 'cos_blocks_cont';
continuous_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + continuous_pathB );
genlib(toolboxname + 'lib', continuous_pathB, %t );

clear continuous_pathB toolboxname
