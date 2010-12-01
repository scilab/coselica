toolboxname = 'cos_mech_plan';
planar_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + planar_pathB);
genlib(toolboxname + 'lib', planar_pathB, %t);

clear planar_pathB toolboxname
