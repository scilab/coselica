blocks_pathB = get_absolute_file_path('buildmacros.sce');
chdir(blocks_pathB);

// directories
dirs = list('Interfaces','Routing','Math','Sources','Continuous','Nonlinear');

// gather information about blocks
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildmacros.sce')
    chdir( '..' );
  end
end

clear d dirs blocks_pathB
