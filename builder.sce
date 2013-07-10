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

// Load manually interface functions and path to Modelica file
// to simulate during documentation compilation

pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Utils/";
cos_utils_lib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Blocks/Continuous/";
cos_blocks_contlib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Blocks/Nonlinear/";
cos_blocks_nllib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Blocks/Interfaces/";
cos_blocks_interflib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Blocks/Math/";
cos_blocks_mathlib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Blocks/Routing/";
cos_blocks_routlib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Blocks/Sources/";
cos_blocks_srcslib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Thermal/HeatTransfer/";
cos_thermal_heattlib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Hydraulic/HydraulicTransfer/";
cos_hydraulic_lib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Electrical/";
cos_eleclib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Mechanics/Rotational/";
cos_mech_rotlib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Mechanics/Planar/";
cos_mech_planlib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Mechanics/Translational/";
cos_mech_translib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Components/Actuators";
cos_compactlib = lib(pathmacros);
pathmacros = pathconvert( toolbox_dir ) + "macros" + filesep() + "Components/PreActuators";
cos_comppreactlib = lib(pathmacros);


global %MODELICA_USER_LIBS;
%MODELICA_USER_LIBS = [%MODELICA_USER_LIBS ; toolbox_dir+"/macros"];


tbx_builder_help(toolbox_dir);
tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

clear toolbox_dir TOOLBOX_NAME TOOLBOX_TITLE cos_mech_translib;

cd(original_dir);
