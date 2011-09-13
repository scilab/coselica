// Coselica Toolbox for Scicoslab
// Copyright (C) 2009-2011  Dirk Reusch, Kybernetik Dr. Reusch
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

function [x,y,typ]=CMPL_Revolute(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    phi_offset=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CMPI_TwoFrames_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPI_TwoFrames_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPI_TwoFrames_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,phi_offset,exprs]=..
        getvalue(['';'CMPL_Revolute';'';'Revolute joint used in loops (1 rotational degree-of-freedom, no states)';''],..
        [' phi_offset [rad] : Relative angle offset (angle = phi + phi_offset)'],..
        list('vec',1),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[1];
      model.equations.parameters(2)=list(phi_offset)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    phi_offset=0;
    exprs=[strcat(sci2exp(phi_offset))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.LoopJoints.Revolute';
      mo.inputs=['frame_a'];
      mo.outputs=['frame_b'];
      mo.parameters=list(['phi_offset'],..
                         list(phi_offset),..
                         [0]);
    model.equations=mo;
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.185,orig(2)+sz(2)*-0.125,""""+model.label+"""",sz(1)*1.38,sz(2)*0.285,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.185-1.38),orig(2)+sz(2)*-0.125,""""+model.label+"""",sz(1)*1.38,sz(2)*0.285,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.4,orig(2)+sz(2)*0.55,sz(1)*0.2,sz(2)*0.1);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.4-0.2),orig(2)+sz(2)*0.55,sz(1)*0.2,sz(2)*0.1);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*0.8,sz(1)*0.4,sz(2)*0.6);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-0.4),orig(2)+sz(2)*0.8,sz(1)*0.4,sz(2)*0.6);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,127,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.6,orig(2)+sz(2)*0.8,sz(1)*0.4,sz(2)*0.6);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.6-0.4),orig(2)+sz(2)*0.8,sz(1)*0.4,sz(2)*0.6);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,127,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*0.795,sz(1)*0.4,sz(2)*0.595);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-0.4),orig(2)+sz(2)*0.795,sz(1)*0.4,sz(2)*0.595);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""off"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.6,orig(2)+sz(2)*0.8,sz(1)*0.4,sz(2)*0.6);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.6-0.4),orig(2)+sz(2)*0.8,sz(1)*0.4,sz(2)*0.6);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""off"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.05,orig(2)+sz(2)*0.445,""a"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.05-0.18),orig(2)+sz(2)*0.445,""a"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(128,128,128);';
          'e.font_foreground=color(128,128,128);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.755,orig(2)+sz(2)*0.43,""b"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.755-0.18),orig(2)+sz(2)*0.43,""b"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(128,128,128);';
          'e.font_foreground=color(128,128,128);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I'];
  end
endfunction
