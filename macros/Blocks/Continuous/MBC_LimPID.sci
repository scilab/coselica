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

function [x,y,typ]=MBC_LimPID(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    k=arg1.graphics.exprs(1);
    Ti=arg1.graphics.exprs(2);
    Td=arg1.graphics.exprs(3);
    yMax=arg1.graphics.exprs(4);
    yMin=arg1.graphics.exprs(5);
    wp=arg1.graphics.exprs(6);
    wd=arg1.graphics.exprs(7);
    Ni=arg1.graphics.exprs(8);
    Nd=arg1.graphics.exprs(9);
    standard_draw(arg1,%f,_MBI_SVcontrol_dp);
  case 'getinputs' then
    [x,y,typ]=_MBI_SVcontrol_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MBI_SVcontrol_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,k,Ti,Td,yMax,yMin,wp,wd,Ni,Nd,exprs]=..
        getvalue(['';'MBC_LimPID';'';'PID controller with limited output, anti-windup compensation and setpoint weighting';''],..
        [' k [-] : Gain of PID block';' Ti [s] : Time constant of Integrator block';' Td [s] : Time constant of Derivative block';' yMax [-] : Upper limit of output';' yMin [-] : Lower limit of output';' wp [-] : Set-point weight for Proportional block (0..1)';' wd [-] : Set-point weight for Derivative block (0..1)';' Ni [-] : Ni*Ti is time constant of anti-windup compensation';' Nd [-] : The higher Nd, the more ideal the derivative block'],..
        list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
    model.in=[1;1];
    model.out=[1];
      model.equations.parameters(2)=list(k,Ti,Td,yMax,yMin,wp,wd,Ni,Nd)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    k=1;
    Ti=0.5;
    Td=0.1;
    yMax=1;
    yMin=-1;
    wp=1;
    wd=0;
    Ni=0.9;
    Nd=10;
    exprs=[strcat(sci2exp(k));strcat(sci2exp(Ti));strcat(sci2exp(Td));strcat(sci2exp(yMax));strcat(sci2exp(yMin));strcat(sci2exp(wp));strcat(sci2exp(wd));strcat(sci2exp(Ni));strcat(sci2exp(Nd))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1;1];
    model.out=[1];
    mo=modelica();
      mo.model='Modelica.Blocks.Continuous.LimPID';
      mo.inputs=['u_s','u_m'];
      mo.outputs=['y'];
      mo.parameters=list(['k','Ti','Td','yMax','yMin','wp','wd','Ni','Nd'],..
                         list(k,Ti,Td,yMax,yMin,wp,wd,Ni,Nd),..
                         [0,0,0,0,0,0,0,0,0]);
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
          'e.foreground=color(0,0,191);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,255);';
          'e.font_foreground=color(0,0,255);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.1;0.1],yy+hh*[0.89;0.05]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(192,192,192);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.1;0.06;0.14;0.1],yy+hh*[0.95;0.84;0.84;0.95]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(192,192,192);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.05;0.91],yy+hh*[0.1;0.1]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(192,192,192);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.95;0.84;0.84;0.95],yy+hh*[0.1;0.14;0.06;0.1]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(192,192,192);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.1;0.1;0.1;0.65;0.9],yy+hh*[0.1;0.75;0.4;0.8;0.8]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.4,orig(2)+sz(2)*0.2,""PID"",sz(1)*0.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.4-0.5),orig(2)+sz(2)*0.2,""PID"",sz(1)*0.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.font_foreground=color(192,192,192);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.in_style=[RealInputStyle() ; RealInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RealOutputStyle()];
  end
endfunction
