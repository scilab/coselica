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

function [x,y,typ]=CMTC_Lever(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    L1=arg1.graphics.exprs(1);
    L2=arg1.graphics.exprs(2);
    L=arg1.graphics.exprs(3);
    standard_draw(arg1,%f,_CMTI_Lever_dp);
  case 'getinputs' then
    [x,y,typ]=_CMTI_Lever_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMTI_Lever_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,L1,L2,L,exprs]=..
        getvalue(['';'CMTC_Lever';'';'Lever assuming small angle deviation (without mass and inertia; geometric constraint)';''],..
        [' L1 [m] : Length of arm 1 (>0)',' L2 [m] : Length of arm 2 (>0)',' L [m] : Geometric constraint L=(L2*s1+L1*s2)/(L1+L2)-s'],..
        list('vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(L1,L2,L)
      model.in=[1];
      model.out=[1;1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    L1=1;
    L2=1;
    L=0;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1;1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Components.Lever';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b1','flange_b2'];
      mo.parameters=list(['L1','L2','L'],..
                         list(L1,L2,L),..
                         [0,0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(L1));strcat(sci2exp(L2));strcat(sci2exp(L))];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.45,orig(2)+sz(2)*0.95,sz(1)*0.1,sz(2)*0.9);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.45-0.1),orig(2)+sz(2)*0.95,sz(1)*0.1,sz(2)*0.9);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=0;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.45,orig(2)+sz(2)*0.55,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.45-0.1),orig(2)+sz(2)*0.55,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(175,175,175);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.45,orig(2)+sz(2)*1,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.45-0.1),orig(2)+sz(2)*1,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(175,175,175);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.45,orig(2)+sz(2)*0.1,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.45-0.1),orig(2)+sz(2)*0.1,sz(1)*0.1,sz(2)*0.1,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(175,175,175);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.015;0.45],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,191,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.55;0.985],yy+hh*[0.95;0.95]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.55;0.985],yy+hh*[0.05;0.05]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0,orig(2)+sz(2)*1,""""+model.label+"""",sz(1)*1,sz(2)*0.3,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*1,""""+model.label+"""",sz(1)*1,sz(2)*0.3,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.675,orig(2)+sz(2)*0.7,""1"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.675-0.175),orig(2)+sz(2)*0.7,""1"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(175,175,175);';
          'e.background=color(175,175,175);';
          'e.font_foreground=color(175,175,175);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.675,orig(2)+sz(2)*0.2,""2"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.675-0.175),orig(2)+sz(2)*0.2,""2"",sz(1)*0.175,sz(2)*0.1,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(175,175,175);';
          'e.background=color(175,175,175);';
          'e.font_foreground=color(175,175,175);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I','I'];
  end
endfunction
