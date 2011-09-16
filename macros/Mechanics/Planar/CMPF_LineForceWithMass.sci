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

function [x,y,typ]=CMPF_LineForceWithMass(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    m=arg1.graphics.exprs(1);
    lengthFraction=arg1.graphics.exprs(2);
    s_small=arg1.graphics.exprs(3);
    standard_draw(arg1,%f,_CMPF_LineForce_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPF_LineForce_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPF_LineForce_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,m,lengthFraction,s_small,exprs]=..
        getvalue(['';'CMPF_LineForceWithMass';'';'General line force component with a point mass on the connection line';''],..
        [' m [kg] : Mass of point mass (> 0) on the connetion line between the origin of frame_a and the origin of frame_b',' lengthFraction [1] : Location of point mass with respect to frame_a as a fraction of the distance from frame_a to frame_b',' s_small [m] : Prevent zero-division if distance between frame_a and frame_b is zero'],..
        list('vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
    model.in=[1;1];
    model.out=[1;1];
      model.equations.parameters(2)=list(m,lengthFraction,s_small)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    m=1;
    lengthFraction=0.5;
    s_small=1.000D-10;
    exprs=[strcat(sci2exp(m));strcat(sci2exp(lengthFraction));strcat(sci2exp(s_small))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1;1];
    model.out=[1;1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Forces.LineForceWithMass';
      mo.inputs=['frame_a','flange_a'];
      mo.outputs=['frame_b','flange_b'];
      mo.parameters=list(['m','lengthFraction','s_small'],..
                         list(m,lengthFraction,s_small),..
                         [0,0,0]);
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
          '  xarc(orig(1)+sz(1)*0.025,orig(2)+sz(2)*0.7,sz(1)*0.4,sz(2)*0.4,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.025-0.4),orig(2)+sz(2)*0.7,sz(1)*0.4,sz(2)*0.4,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.075,orig(2)+sz(2)*0.65,sz(1)*0.3,sz(2)*0.3,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.075-0.3),orig(2)+sz(2)*0.65,sz(1)*0.3,sz(2)*0.3,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.575,orig(2)+sz(2)*0.7,sz(1)*0.4,sz(2)*0.4,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.575-0.4),orig(2)+sz(2)*0.7,sz(1)*0.4,sz(2)*0.4,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.615,orig(2)+sz(2)*0.645,sz(1)*0.3,sz(2)*0.295,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.615-0.3),orig(2)+sz(2)*0.645,sz(1)*0.3,sz(2)*0.295,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(128,128,128);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.225,orig(2)+sz(2)*-0.065,""""+model.label+"""",sz(1)*1.45,sz(2)*0.3,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.225-1.45),orig(2)+sz(2)*-0.065,""""+model.label+"""",sz(1)*1.45,sz(2)*0.3,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.3,orig(2)+sz(2)*0.705,sz(1)*0.42,sz(2)*0.405);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.3-0.42),orig(2)+sz(2)*0.705,sz(1)*0.42,sz(2)*0.405);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(255,255,255);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.15,orig(2)+sz(2)*0.575,sz(1)*0.145,sz(2)*0.14,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.15-0.145),orig(2)+sz(2)*0.575,sz(1)*0.145,sz(2)*0.14,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.7,orig(2)+sz(2)*0.57,sz(1)*0.145,sz(2)*0.14,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.7-0.145),orig(2)+sz(2)*0.57,sz(1)*0.145,sz(2)*0.14,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.22;0.22;0.35;0.35;0.2;0.2],yy+hh*[0.5;0.615;0.615;0.85;0.85;1.005]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.775;0.775;0.65;0.65;0.8;0.8],yy+hh*[0.495;0.6;0.6;0.85;0.85;1]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.22;0.775],yy+hh*[0.5;0.495]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=2;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.46,orig(2)+sz(2)*0.54,sz(1)*0.08,sz(2)*0.08,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.46-0.08),orig(2)+sz(2)*0.54,sz(1)*0.08,sz(2)*0.08,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.out_implicit=['I','I'];
  end
endfunction
