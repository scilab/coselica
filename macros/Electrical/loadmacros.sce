mode(-1)
pathL=get_absolute_file_path('loadmacros.sce')
disp('Loading macros  in ' +pathL)
load(pathL+'/lib')

modelica_libs($+1)=pathL;

clear pathL

