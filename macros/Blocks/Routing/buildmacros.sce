toolboxname = 'cos_blocks_rout';
routing_pathB = get_absolute_file_path('buildmacros.sce');

disp('Building macros in ' + routing_pathB);
genlib(toolboxname + 'lib', routing_pathB, %t);

clear routing_pathB toolboxname
