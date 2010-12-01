toolboxname = 'cos_mech_trans';
translational_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + translational_pathB);
genlib(toolboxname + 'lib', translational_pathB, %t);

clear translational_pathB toolboxname
