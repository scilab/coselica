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

function tbx_build_blocks(module, names, blockpath)
    // Build a default block instance
    //
    // Calling Sequence
    //   tbx_build_blocks(module, names)
    //
    // Parameters
    // module: toolbox base directory
    // names: list of block names (sci file name without extension)

    if argn(2) <> [2 3] then
        error(msprintf(gettext("%s: Wrong number of input arguments: %d to %d expected.\n"),"tbx_build_blocks",2,3));
    end

    // checking module argument
    if type(module) <> 10 then
        error(msprintf(gettext("%s: Wrong type for input argument #%d: A string expected.\n"),"tbx_build_blocks",1));
    end
    if size(module,"*") <> 1 then
        error(msprintf(gettext("%s: Wrong size for input argument #%d: A string expected.\n"),"tbx_build_blocks",1));
    end
    if ~isdir(module) then
        error(msprintf(gettext("%s: The directory ''%s'' doesn''t exist or is not read accessible.\n"),"tbx_build_blocks",module));
    end

    // checking names argument
    if type(names) <> 10 then
        error(msprintf(gettext("%s: Wrong type for input argument #%d: A string expected.\n"),"tbx_build_blocks",2));
    end

    if exists("blockpath", "local")
      sciFilePath = blockpath + filesep();
    else
      sciFilePath = module + filesep() + "macros" + filesep();
    end


    mprintf(gettext("Building blocks...\n"));

    // load Xcos libraries when not already loaded.
    if ~exists("scicos_diagram") then loadXcosLibs(); end

    sciFiles = pathconvert(sciFilePath) + names + ".sci";
    h5Files = pathconvert(module + "/images/h5/") + names + ".h5";
    gif_tlbx = pathconvert(module + "/images/gif");
    gifFiles = pathconvert(module + "/images/gif/") + names + ".gif";
    svg_tlbx = pathconvert(module + "/images/svg");
    svgFiles = pathconvert(module + "/images/svg/") + names + ".svg";
    handle = [];
    for i=1:size(names, "*")
        // load the interface function
        exec(sciFiles(i), -1);

        // export the instance
        execstr(msprintf("scs_m = %s (''define'');", names(i)));
        if ~export_to_hdf5(h5Files(i), "scs_m") then
            error(msprintf(gettext("%s: Unable to export %s to %s.\n"),"tbx_build_blocks",names(i), h5Files(i)));
        end

        block = scs_m;
        // export a gif file if it doesn't exist
        if ~isfile(gifFiles(i)) then
          handle = gcf();
          if ~generateBlockImage(block, gif_tlbx, names(i), handle, "gif", %t) then
            error(msprintf(gettext("%s: Unable to export %s to %s.\n"),"tbx_build_blocks",names(i), gifFiles(i)));
          end
        end

        // export an svg file if it doesn't exist
        if ~isfile(svgFiles(i)) then
         handle = gcf();
         if ~generateBlockImage(block, svg_tlbx, names(i), handle, "svg", %f) then
           error(msprintf(gettext("%s: Unable to export %s to %s.\n"),"tbx_build_blocks",names(i), svgFiles(i)));
         end
        end
    end
    if (~isempty(handle))
      delete(handle);
    end
endfunction

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
tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

clear toolbox_dir TOOLBOX_NAME TOOLBOX_TITLE;

cd(original_dir);