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

function [x,y,typ]=CMP_World(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    g=arg1.graphics.exprs(1);
    n=arg1.graphics.exprs(2);
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
      [ok,g,n,exprs]=..
        getvalue(['';'CMP_World';'';'World coordinate system with uniform gravity field';''],..
        [' g [m/s2] : Constant gravity acceleration';' n [-] : Direction of gravity resolved in world frame (gravity = g*n/length(n))'],..
        list('vec',1,'vec',2),exprs);
      if ~ok then break, end
    model.in=[];
    model.out=[1];
      model.equations.parameters(2)=list(g,n)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    g=9.81;
    n=[0,-1];
    exprs=[strcat(sci2exp(g));strcat(sci2exp(n))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.World';
      mo.inputs=[];
      mo.outputs=['frame_b'];
      mo.parameters=list(['g','n'],..
                         list(g,n),..
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
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0;0],yy+hh*[-0.09;0.805]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.5;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0;-0.1;0.1;0;0],yy+hh*[1;0.8;0.8;1;1]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[-0.095;0.795],yy+hh*[0;0]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.5;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.995;0.795;0.795;0.995],yy+hh*[0;0.1;-0.1;0]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.2,orig(2)+sz(2)*1.015,""""+model.label+"""",sz(1)*1.4,sz(2)*0.31,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.2-1.4),orig(2)+sz(2)*1.015,""""+model.label+"""",sz(1)*1.4,sz(2)*0.31,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.975,orig(2)+sz(2)*-0.31,""x"",sz(1)*0.245,sz(2)*0.245,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.975-0.245),orig(2)+sz(2)*-0.31,""x"",sz(1)*0.245,sz(2)*0.245,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.35,orig(2)+sz(2)*0.885,""y"",sz(1)*0.255,sz(2)*0.25,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.35-0.255),orig(2)+sz(2)*0.885,""y"",sz(1)*0.255,sz(2)*0.25,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.22;0.22],yy+hh*[0.89;0.37]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.16;0.22;0.28;0.16],yy+hh*[0.37;0.17;0.37;0.37]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.51;0.51],yy+hh*[0.89;0.37]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.45;0.51;0.57;0.45],yy+hh*[0.37;0.17;0.37;0.37]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.83;0.83],yy+hh*[0.9;0.37]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.77;0.83;0.89;0.77],yy+hh*[0.37;0.17;0.37;0.37]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.23,orig(2)+sz(2)*-0.24,""g=""+string(g)+"""",sz(1)*1.5,sz(2)*0.22,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.23-1.5),orig(2)+sz(2)*-0.24,""g=""+string(g)+"""",sz(1)*1.5,sz(2)*0.22,""fill"");';
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
    x.graphics.out_style=[PlanOutputStyle()];
end
endfunction
