hydraulic_pathB = get_absolute_file_path('buildmacros.sce');
chdir(hydraulic_pathB);

// directories
dirs=['HydraulicTransfer'];

// Load Utils
getd(hydraulic_pathB+".."+filesep()+"Utils");

// gather information about blocks
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildmacros.sce');
    chdir( '..' );
  end
end

clear d dirs hydraulic_pathB

