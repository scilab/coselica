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

function [x,y,typ]=CMPL_Prismatic(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    n=arg1.graphics.exprs(1);
    s_offset=arg1.graphics.exprs(2);
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
      [ok,n,s_offset,exprs]=..
        getvalue(['';'CMPL_Prismatic';'';'Prismatic joint used in loops (1 translational degree-of-freedom, no states)';''],..
        [' n [-] : Axis of translation resolved in frame_a (= same as in frame_b)';' s_offset [m] : Relative distance offset (distance between frame_a and frame_b = s_offset + s)'],..
        list('vec',2,'vec',1),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[1];
      model.equations.parameters(2)=list(n,s_offset)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    n=[1,0];
    s_offset=0;
    exprs=[strcat(sci2exp(n));strcat(sci2exp(s_offset))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.LoopJoints.Prismatic';
      mo.inputs=['frame_a'];
      mo.outputs=['frame_b'];
      mo.parameters=list(['n','s_offset'],..
                         list(n,s_offset),..
                         [0,0]);
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
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*0.705,sz(1)*0.35,sz(2)*0.455);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-0.35),orig(2)+sz(2)*0.705,sz(1)*0.35,sz(2)*0.455);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,127,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=0;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*0.75,sz(1)*0.35,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-0.35),orig(2)+sz(2)*0.75,sz(1)*0.35,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=0;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.35,orig(2)+sz(2)*0.6,sz(1)*0.65,sz(2)*0.25);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.35-0.65),orig(2)+sz(2)*0.6,sz(1)*0.65,sz(2)*0.25);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,127,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=0;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.35,orig(2)+sz(2)*0.65,sz(1)*0.65,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.35-0.65),orig(2)+sz(2)*0.65,sz(1)*0.65,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=0;';
          'xpoly(xx+ww*[0.35;0.35],yy+hh*[0.25;0.75]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[1;1],yy+hh*[0.35;0.605]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.8,orig(2)+sz(2)*0.435,""b"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.8-0.18),orig(2)+sz(2)*0.435,""b"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(128,128,128);';
          'e.font_foreground=color(128,128,128);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.025,orig(2)+sz(2)*0.455,""a"",sz(1)*0.175,sz(2)*0.11,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.025-0.175),orig(2)+sz(2)*0.455,""a"",sz(1)*0.175,sz(2)*0.11,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(128,128,128);';
          'e.font_foreground=color(128,128,128);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.21,orig(2)+sz(2)*0.81,""n=""+string(n)+"""",sz(1)*1.445,sz(2)*0.195,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.21-1.445),orig(2)+sz(2)*0.81,""n=""+string(n)+"""",sz(1)*1.445,sz(2)*0.195,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.175,orig(2)+sz(2)*-0.085,""""+model.label+"""",sz(1)*1.38,sz(2)*0.285,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.175-1.38),orig(2)+sz(2)*-0.085,""""+model.label+"""",sz(1)*1.38,sz(2)*0.285,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I'];
  end
endfunction
