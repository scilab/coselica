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

function [x,y,typ]=CMRS_ConstantSpeed(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    w_fixed=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CMRS_ConstantTorque_dp);
  case 'getinputs' then
    [x,y,typ]=_CMRS_ConstantTorque_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMRS_ConstantTorque_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,w_fixed,exprs]=..
        getvalue(['';'CMRS_ConstantSpeed';'';'Constant speed, not dependent on torque';''],..
        [' w_fixed [rad/s] : Fixed speed'],..
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(w_fixed)
      model.in=[];
      model.out=[1;1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    w_fixed=1;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[];
    model.out=[1;1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Rotational.Sources.ConstantSpeed';
      mo.inputs=[];
      mo.outputs=['flange','support'];
      mo.parameters=list(['w_fixed'],..
                         list(w_fixed),..
                         [0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(w_fixed))];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.02,orig(2)+sz(2)*0.98,sz(1)*0.96,sz(2)*0.96);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.02-0.96),orig(2)+sz(2)*0.98,sz(1)*0.96,sz(2)*0.96);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(255,255,255);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0.5],yy+hh*[0.19;0]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.04;0.12;0.23;0.35;0.43;0.55;0.63;0.73;0.82],yy+hh*[0.5;0.68;0.81;0.9;0.94;0.96;0.95;0.9;0.81]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*1,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*1,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.97;0.9;0.75;0.97],yy+hh*[0.58;0.87;0.76;0.58]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.21;0.29;0.4;0.5;0.59;0.67;0.72;0.77;0.8],yy+hh*[0.09;0.16;0.22;0.23;0.22;0.19;0.14;0.09;0.03]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.175;0.27;0.21;0.175],yy+hh*[0.01;0.1;0.14;0.01]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.5;0.5],yy+hh*[0;1]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.08,orig(2)+sz(2)*0.3,""""+string(w_fixed)+"""",sz(1)*1.22,sz(2)*0.12,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.08-1.22),orig(2)+sz(2)*0.3,""""+string(w_fixed)+"""",sz(1)*1.22,sz(2)*0.12,""fill"");';
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
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[RotOutputStyle(), RotOutputStyle()];
  end
endfunction
