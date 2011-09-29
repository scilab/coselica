pathB = get_absolute_file_path('buildmacros.sce');
chdir(pathB);

// directories
dirs=['Utils', 'Electrical','Mechanics','Thermal','Blocks'];

// gather information about blocks
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildmacros.sce')
    chdir( '..' );
  end
end

clear d dirs pathB
