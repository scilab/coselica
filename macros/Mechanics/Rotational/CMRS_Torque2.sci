// Coselica Toolbox for Xcos
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
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

function [x,y,typ]=CMRS_Torque2(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    standard_draw(arg1,%f,_MMR_Torque2_dp);
  case 'getinputs' then
    [x,y,typ]=_MMR_Torque2_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MMR_Torque2_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
  case 'define' then
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1;1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Rotational.Sources.Torque2';
      mo.inputs=['flange_a','tau'];
      mo.outputs=['flange_b'];
      mo.parameters=list([],list(),[]);
    model.equations=mo;
    exprs=[];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*0.1,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*0.1,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.11;0.155;0.055;0.11],yy+hh*[0.62;0.585;0.5;0.62]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.5;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.13;0.15;0.175;0.2;0.22;0.25;0.295;0.325;0.345;0.37;0.395;0.415;0.435;0.45],yy+hh*[0.6;0.615;0.63;0.64;0.645;0.65;0.65;0.645;0.64;0.63;0.615;0.6;0.575;0.545]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.5;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.87;0.85;0.825;0.8;0.78;0.75;0.705;0.675;0.655;0.63;0.605;0.585;0.565;0.55],yy+hh*[0.6;0.615;0.63;0.64;0.645;0.65;0.65;0.645;0.64;0.63;0.615;0.6;0.575;0.545]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.5;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.945;0.89;0.845;0.945],yy+hh*[0.5;0.62;0.585;0.5]);';
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
    x.graphics.in_style=[RotInputStyle(), RealInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RotOutputStyle()];
  end
endfunction
