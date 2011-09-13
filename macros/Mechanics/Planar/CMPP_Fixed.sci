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

function [x,y,typ]=CMPP_Fixed(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    r=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CMP_World_dp);
  case 'getinputs' then
    [x,y,typ]=_CMP_World_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMP_World_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,r,exprs]=..
        getvalue(['';'CMPP_Fixed';'';'Frame fixed in the world frame at a given position (used for closing loops)';''],..
        [' r [m] : Position vector from world frame to frame_b, resolved in world frame'],..
        list('vec',2),exprs);
      if ~ok then break, end
    model.in=[];
    model.out=[1];
      model.equations.parameters(2)=list(r)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    r=[0,0];
    exprs=[strcat(sci2exp(r))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Parts.Fixed';
      mo.inputs=[];
      mo.outputs=['frame_b'];
      mo.parameters=list(['r'],..
                         list(r),..
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
          '  xrect(orig(1)+sz(1)*0.05,orig(2)+sz(2)*0.95,sz(1)*0.9,sz(2)*0.9);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.05-0.9),orig(2)+sz(2)*0.95,sz(1)*0.9,sz(2)*0.9);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(255,255,255);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.21,orig(2)+sz(2)*1.03,""""+model.label+"""",sz(1)*1.46,sz(2)*0.32,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.21-1.46),orig(2)+sz(2)*1.03,""""+model.label+"""",sz(1)*1.46,sz(2)*0.32,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.5;0.5],yy+hh*[1;0]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0],yy+hh*[0.1;0.4]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0],yy+hh*[0.3;0.6]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0],yy+hh*[0.5;0.8]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0],yy+hh*[0.7;1]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;1],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.23,orig(2)+sz(2)*-0.24,""r=""+string(r)+"""",sz(1)*1.5,sz(2)*0.22,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.23-1.5),orig(2)+sz(2)*-0.24,""r=""+string(r)+"""",sz(1)*1.5,sz(2)*0.22,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=[];
    x.graphics.out_implicit=['I'];
  end
endfunction
