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

function [x,y,typ]=CMTC_ActuatedPulley(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    r=arg1.graphics.exprs(1);
    L=arg1.graphics.exprs(2);
    standard_draw(arg1,%f,_CMTC_ActuatedPulley_dp);
  case 'getinputs' then
    [x,y,typ]=_CMTC_ActuatedPulley_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMTC_ActuatedPulley_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,r,L,exprs]=..
        getvalue(['';'CMTC_ActuatedPulley';'';'Actuated Pulley (without mass and inertia; geometric constraint)';''],..
        [' r [m] : Radius of pulley (>0)',' L [m] : Geometric constraint L=(s1+s2)/2-s'],..
        list('vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(r,L)
      model.in=[1];
      model.out=[1;1;1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    r=1;
    L=0;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1;1;1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Components.ActuatedPulley';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b1','flange_b2','axle'];
      mo.parameters=list(['r','L'],..
                         list(r,L),..
                         [0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(r));strcat(sci2exp(L))];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.25,orig(2)+sz(2)*0.75,sz(1)*0.5,sz(2)*0.5,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.25-0.5),orig(2)+sz(2)*0.75,sz(1)*0.5,sz(2)*0.5,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.015;0.45],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,191,0);';
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
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0.985],yy+hh*[0.75;0.75]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0.985],yy+hh*[0.25;0.25]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0,orig(2)+sz(2)*0.825,""""+model.label+"""",sz(1)*1,sz(2)*0.3,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*0.825,""""+model.label+"""",sz(1)*1,sz(2)*0.3,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.825,orig(2)+sz(2)*0.8,""1"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.825-0.175),orig(2)+sz(2)*0.8,""1"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(175,175,175);';
          'e.background=color(175,175,175);';
          'e.font_foreground=color(175,175,175);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.825,orig(2)+sz(2)*0.1,""2"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.825-0.175),orig(2)+sz(2)*0.1,""2"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(175,175,175);';
          'e.background=color(175,175,175);';
          'e.font_foreground=color(175,175,175);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.5;0.557;0.606;0.636;0.65;0.637;0.606;0.557;0.5],yy+hh*[0.35;0.364;0.394;0.443;0.5;0.556;0.606;0.636;0.65]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0.555;0.54;0.5],yy+hh*[0.65;0.655;0.615;0.65]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.45,orig(2)+sz(2)*0.25,sz(1)*0.1,sz(2)*0.25);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.45-0.1),orig(2)+sz(2)*0.25,sz(1)*0.1,sz(2)*0.25);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=0;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I','I','I'];
  end
endfunction
