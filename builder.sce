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

// Action
// =============================================================================

tbx_builder_macros(toolbox_dir);
tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

f = gcf(); // to generate images

// Build xcos palette
// =============================================================================

loadXcosLibs();
if fileinfo(toolbox_dir + filesep() + "images") == [] then
  mkdir(toolbox_dir + filesep() + "images");
end
if fileinfo(toolbox_dir + filesep() + "images/h5") == [] then
  mkdir(toolbox_dir + filesep() + "images/h5");
end
if fileinfo(toolbox_dir + filesep() + "images/gif") == [] then
  mkdir(toolbox_dir + filesep() + "images/gif");
end
if fileinfo(toolbox_dir + filesep() + "images/svg") == [] then
  mkdir(toolbox_dir + filesep() + "images/svg");
end

libraries = toolbox_dir + filesep() + [..
"macros/Electrical";..
"macros/Thermal/HeatTransfer";..
"macros/Blocks/Math";..
"macros/Blocks/Sources";..
"macros/Blocks/Routing";..
"macros/Blocks/Continuous";..
"macros/Blocks/Interfaces";..
"macros/Blocks/Nonlinear";..
"macros/Mechanics/Translational";..
"macros/Mechanics/Rotational";..
"macros/Mechanics/Planar";..
]';

getd(libraries);


// utility function to add all interface functions from a path to a palette.
function xpal = add_to_palette(xpal, currentPalRoot)
  interfaces = basename(ls(currentPalRoot + filesep() + "*.sci"));
  valid_indexes = grep(interfaces, "/^[^_].*$/", 'r'); // remove the macros starting with an underscore.
  interfaces = interfaces(valid_indexes);

  h5_instances = toolbox_dir + filesep() + "images/h5/" + interfaces + ".h5";
  pal_icons = toolbox_dir + filesep() + "images/gif/" + interfaces + ".gif";
  graph_icons = toolbox_dir + filesep() + "images/svg/" + interfaces + ".svg";

  for i=1:size(interfaces,1)
    // generate the instance file
    execstr("scs_m = " + interfaces(i) + '(''define'')');
    export_to_hdf5(h5_instances(i), 'scs_m');

    // generate the gif file
    if ~isfile(pal_icons(i))
      generateBlockImage(scs_m, dirname(pal_icons(i)), interfaces(i), f, "gif", %t);
    end

    // generate the svg file
    if ~isfile(graph_icons(i))
      generateBlockImage(scs_m, dirname(graph_icons(i)), interfaces(i), f, "svg", %f);
    end

    // register to the palette.
    xpal = xcosPalAddBlock(xpal, h5_instances(i), pal_icons(i), graph_icons(i));
  end
endfunction

///////////////////////////////
// Blocks continuous palette //
///////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Blocks/Continuous";
xpal = xcosPal("Continuous");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_blocks_continuous.xpal');

//////////////////////////////
// Blocks nonlinear palette //
//////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Blocks/Nonlinear";
xpal = xcosPal("Non linear");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_blocks_nonlinear.xpal');

//////////////////////////////
// Blocks interface palette //
//////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Blocks/Interfaces";
xpal = xcosPal("Interface");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_blocks_interface.xpal');

/////////////////////////
// Blocks math palette //
/////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Blocks/Math";
xpal = xcosPal("Math");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_blocks_math.xpal');

////////////////////////////
// Blocks routing palette //
////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Blocks/Routing";
xpal = xcosPal("Routing");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_blocks_routing.xpal');

////////////////////////////
// Blocks sources palette //
////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Blocks/Sources";
xpal = xcosPal("Sources");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_blocks_sources.xpal');

//////////////////////////////////
// Thermal HeatTransfer palette //
//////////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Thermal/HeatTransfer";
xpal = xcosPal("Thermal heat transfert");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_thermal_heattransfert.xpal');

////////////////////////
// Electrical palette //
////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Electrical";
xpal = xcosPal("Electrical");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_electrical.xpal');

//////////////////////////////////
// Mechanics rotational palette //
//////////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Mechanics/Rotational";
xpal = xcosPal("Mechanices rotational");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_mechanics_rotational.xpal');

//////////////////////////////
// Mechanics planar palette //
//////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Mechanics/Planar";
xpal = xcosPal("Mechanices planar");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_mechanics_planar.xpal');

/////////////////////////////////////
// Mechanics translational palette //
/////////////////////////////////////

currentPalRoot = toolbox_dir + filesep() + "macros/Mechanics/Translational";
xpal = xcosPal("Mechanices translational");
xpal = add_to_palette(xpal, currentPalRoot);

xcosPalExport(xpal, toolbox_dir + '/coselica_mechanics_translational.xpal');

// Clean variables
// =============================================================================
delete(f);
clear toolbox_dir TOOLBOX_NAME TOOLBOX_TITLE xpal currentPalRoot add_to_palette;

cd(original_dir);