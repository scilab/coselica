blocks_pathB = get_absolute_file_path('buildmacros.sce');
chdir(blocks_pathB);

// directories
dirs = ['Interfaces','Routing','Math','Sources','Continuous','Nonlinear'];

// Load Utils
getd(blocks_pathB+".."+filesep()+"Utils");

// gather information about blocks
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildmacros.sce')
    chdir( '..' );
  end
end

getd(blocks_pathB+dirs);
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildblocks.sce')
    chdir( '..' );
  end
end

clear d dirs blocks_pathB
