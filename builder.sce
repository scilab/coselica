// Copyright (C) 2010 - DIGITEO

// This file is released into the public domain

mode(-1);
lines(0);

TOOLBOX_NAME  = "coselica";
TOOLBOX_TITLE = "COSELICA";
original_dir = pwd();
toolbox_dir   = get_absolute_file_path("builder.sce");

// Check Scilab's version
// =============================================================================

try
v = getversion("scilab");
catch
error(gettext("Scilab 5.2 or more is required."));
end

if v(2) < 3 then
	// new API in scilab 5.3
	error(gettext('Scilab 5.3 or more is required.'));
end

// Check development_tools module avaibility
// =============================================================================

if ~with_module('development_tools') then
  error(msprintf(gettext('%s module not installed."),'development_tools'));
end

// Build xcos palette
// =============================================================================

loadXcosLibs();
pathToCreate = toolbox_dir + filesep() + "images" + [ ""
                    filesep() + "h5"
                    filesep() + "gif"
                    filesep() + "svg"]
for i = 1:size(pathToCreate, "*")
  if (isdir(pathToCreate(i)) == %f)
    mkdir(pathToCreate(i))
  end
end

// Action
// =============================================================================

tbx_builder_macros(toolbox_dir);
tbx_builder_help(toolbox_dir);
tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

clear toolbox_dir TOOLBOX_NAME TOOLBOX_TITLE;

cd(original_dir);