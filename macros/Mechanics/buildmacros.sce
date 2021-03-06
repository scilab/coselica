mechanics_pathB = get_absolute_file_path('buildmacros.sce');
chdir(mechanics_pathB);

// directories
dirs=['Translational','Rotational','Planar'];

// Load Utils
getd(mechanics_pathB+".."+filesep()+"Utils");

// gather information about blocks
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildmacros.sce')
    chdir( '..' );
  end
end

clear d dirs mechanics_pathB

