toolboxname = 'cos_thermal_heattr';
heattransfer_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + heattransfer_pathB);
genlib(toolboxname + 'lib', heattransfer_pathB, %t);

clear heattransfer_pathB toolboxname
