// Coselica Toolbox for Scicoslab
// Copyright (C) 2009, 2010  Dirk Reusch, Kybernetik Dr. Reusch
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

function [x,y,typ]=MEAS_ConstantVoltage(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    V=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_MEAI_OnePort_dp);
  case 'getinputs' then
    [x,y,typ]=_MEAI_OnePort_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MEAI_OnePort_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,V,exprs]=...
        getvalue(['';'MEAS_ConstantVoltage';'';'Source for constant voltage';''],...
        [' V [V] : Value of constant voltage'],...
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(V)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    V=1;
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Modelica.Electrical.Analog.Sources.ConstantVoltage';
      mo.inputs=['p'];
      mo.outputs=['n'];
      mo.parameters=list(['V'],...
                         list(V),...
                         [0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(V)];
    gr_i=[...
          'if orient then';...
          '  xx=orig(1);yy=orig(2);';...
          '  ww=sz(1);hh=sz(2);';...
          'else';...
          '  xx=orig(1)+sz(1);yy=orig(2);';...
          '  ww=-sz(1);hh=sz(2);';...
          'end';...
          'xpoly(xx+ww*[0.05;0.45],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'xpoly(xx+ww*[0.45;0.45],yy+hh*[0.8;0.2]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'xpoly(xx+ww*[0.5;0.5],yy+hh*[0.65;0.35]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'xpoly(xx+ww*[0.5;0.95],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*0,orig(2)+sz(2)*-0.1,""""+model.label+""=""+string(V)+"""",sz(1)*1,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*-0.1,""""+model.label+""=""+string(V)+"""",sz(1)*1,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,255);';...
          'e.font_foreground=color(0,0,255);';...
          'e.fill_mode=""off"";';...
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[ElecInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[ElecOutputStyle()];
  end
endfunction
