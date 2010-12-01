// Coselica Toolbox for Scicoslab
// Copyright (C) 2009  Dirk Reusch, Kybernetik Dr. Reusch
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

function [x,y,typ]=MEAB_HeatingResistor(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    R_ref=arg1.graphics.exprs(1);
    T_ref=arg1.graphics.exprs(2);
    alpha=arg1.graphics.exprs(3);
    standard_draw(arg1,%f,_MEAB_HeatingResistor_dp);
  case 'getinputs' then
    [x,y,typ]=_MEAB_HeatingResistor_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MEAB_HeatingResistor_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,R_ref,T_ref,alpha,exprs]=...
        getvalue(['';'MEAB_HeatingResistor';'';'Temperature dependent electrical resistor';''],...
        [' R_ref [Ohm] : Resistance at temperature T_ref',' T_ref [K] : Reference temperature',' alpha [1/K] : Temperature coefficient of resistance'],...
        list('vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(R_ref,T_ref,alpha)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    R_ref=1;
    T_ref=300;
    alpha=0;
    model.sim='MEAB_HeatingResistor';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MEAB_HeatingResistor';
      mo.inputs=['p','heatPort'];
      mo.outputs=['n'];
      mo.parameters=list(['R_ref','T_ref','alpha'],...
                         list(R_ref,T_ref,alpha),...
                         [0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(R_ref);sci2exp(T_ref);sci2exp(alpha)];
    gr_i=[...
          'if orient then';...
          '  xx=orig(1);yy=orig(2);';...
          '  ww=sz(1);hh=sz(2);';...
          'else';...
          '  xx=orig(1)+sz(1);yy=orig(2);';...
          '  ww=-sz(1);hh=sz(2);';...
          'end';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.21,orig(2)+sz(2)*0.8,""""+model.label+"""",sz(1)*1.425,sz(2)*0.29,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.21-1.425),orig(2)+sz(2)*0.8,""""+model.label+"""",sz(1)*1.425,sz(2)*0.29,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,255);';...
          'e.fill_mode=""off"";';...
          'xpoly(xx+ww*[0.05;0.15],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.85;0.95],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.15,orig(2)+sz(2)*0.65,sz(1)*0.7,sz(2)*0.3);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.15-0.7),orig(2)+sz(2)*0.65,sz(1)*0.7,sz(2)*0.3);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(255,255,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.5;0.5],yy+hh*[0.35;0.045]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(191,0,0);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.24;0.74],yy+hh*[0.25;0.75]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.7;0.75;0.77;0.7],yy+hh*[0.76;0.71;0.78;0.76]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
         ];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.out_implicit=['I'];
  end
endfunction
