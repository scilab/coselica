thermal_pathB = get_absolute_file_path('buildmacros.sce');
chdir(thermal_pathB);

// directories
dirs=['HeatTransfer'];

// gather information about blocks
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildmacros.sce')
    chdir( '..' );
  end
end

clear d dirs thermal_pathB

