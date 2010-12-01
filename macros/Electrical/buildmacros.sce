toolboxname = 'cos_elec';
electrical_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + electrical_pathB );
genlib(toolboxname + 'lib', electrical_pathB, %t );

clear  electrical_pathB toolboxname
