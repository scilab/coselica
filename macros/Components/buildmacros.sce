components_pathB = get_absolute_file_path('buildmacros.sce');
chdir(components_pathB);

// directories
dirs=['Actuators','PreActuators'];

// Load Utils
getd(components_pathB+".."+filesep()+"Utils");

// gather information about blocks
for d = dirs
  if isdir( d ) then
    chdir( d );
    exec('buildmacros.sce');
    chdir( '..' );
  end
end

clear d dirs components_pathB

