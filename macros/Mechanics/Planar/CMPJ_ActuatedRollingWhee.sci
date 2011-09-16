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

function [x,y,typ]=CMPJ_ActuatedRollingWhee(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    radius=arg1.graphics.exprs(1);
    n=arg1.graphics.exprs(2);
    standard_draw(arg1,%f,_CMPJ_ActuatedWheel_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPJ_ActuatedWheel_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPJ_ActuatedWheel_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,radius,n,exprs]=..
        getvalue(['';'CMPJ_ActuatedRollingWhee';'';'Joint that describes an ideal actuated rolling wheel (1 non-holonomic constraint, no states)';''],..
        [' radius [m] : Radius of wheel',' n [-] : Wheel axis resolved in frame_a'],..
        list('vec',1,'vec',2),exprs);
      if ~ok then break, end
    model.in=[1;1];
    model.out=[1];
      model.equations.parameters(2)=list(radius,n)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    radius=1;
    n=[0,1];
    exprs=[strcat(sci2exp(radius));strcat(sci2exp(n))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1;1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Joints.ActuatedRollingWheel';
      mo.inputs=['frame_a','bearing'];
      mo.outputs=['axis'];
      mo.parameters=list(['radius','n'],..
                         list(radius,n),..
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
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*0.1,sz(1)*1,sz(2)*0.1);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*0.1,sz(1)*1,sz(2)*0.1);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(175,175,175);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.1,orig(2)+sz(2)*0.9,sz(1)*0.8,sz(2)*0.8,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.1-0.8),orig(2)+sz(2)*0.9,sz(1)*0.8,sz(2)*0.8,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.065,orig(2)+sz(2)*0.525,sz(1)*0.385,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.065-0.385),orig(2)+sz(2)*0.525,sz(1)*0.385,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(175,175,175);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.45,orig(2)+sz(2)*0.55,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.45-0.1),orig(2)+sz(2)*0.55,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.23,orig(2)+sz(2)*-0.24,""n=""+string(n)+"""",sz(1)*1.5,sz(2)*0.22,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.23-1.5),orig(2)+sz(2)*-0.24,""n=""+string(n)+"""",sz(1)*1.5,sz(2)*0.22,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.55,orig(2)+sz(2)*0.92,""""+model.label+"""",sz(1)*1,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.55-1),orig(2)+sz(2)*0.92,""""+model.label+"""",sz(1)*1,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.15;0.25],yy+hh*[0.555;0.555]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.15;0.25],yy+hh*[0.445;0.445]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.2;0.2],yy+hh*[0.555;0.95]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0.5],yy+hh*[0.555;0.95]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.2;0.2],yy+hh*[0.4;0.445]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.out_implicit=['I'];
  end
endfunction
