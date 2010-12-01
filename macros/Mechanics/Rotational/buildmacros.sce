toolboxname = 'cos_mech_rot';
rotational_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + rotational_pathB);
genlib(toolboxname + 'lib', rotational_pathB, %t);

clear rotational_pathB toolboxname
