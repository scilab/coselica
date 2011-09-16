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

function [x,y,typ]=CEAS_ZDiode(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    Ids=arg1.graphics.exprs(1);
    Vt=arg1.graphics.exprs(2);
    Maxexp=arg1.graphics.exprs(3);
    R=arg1.graphics.exprs(4);
    Bv=arg1.graphics.exprs(5);
    Ibv=arg1.graphics.exprs(6);
    Nbv=arg1.graphics.exprs(7);
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
      [ok,Ids,Vt,Maxexp,R,Bv,Ibv,Nbv,exprs]=...
        getvalue(['';'CEAS_ZDiode';'';'Zener Diode with 3 working areas';''],...
        [' Ids [A] : Saturation current';' Vt [V] : Voltage equivalent of temperature (kT/qn)';' Maxexp [-] : Max. exponent for linear continuation';' R [Ohm] : Parallel ohmic resistance';' Bv [V] : Breakthrough voltage = Zener- or Z-voltage';' Ibv [A] : Breakthrough knee current';' Nbv [-] : Breakthrough emission coefficient'],...
        list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(Ids,Vt,Maxexp,R,Bv,Ibv,Nbv)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    Ids=0.000001;
    Vt=0.04;
    Maxexp=30;
    R=1.000D+08;
    Bv=5.1;
    Ibv=0.7;
    Nbv=0.74;
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Coselica.Electrical.Analog.Semiconductors.ZDiode';
      mo.inputs=['p'];
      mo.outputs=['n'];
      mo.parameters=list(['Ids','Vt','Maxexp','R','Bv','Ibv','Nbv'],...
                         list(Ids,Vt,Maxexp,R,Bv,Ibv,Nbv),...
                         [0,0,0,0,0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(Ids);sci2exp(Vt);sci2exp(Maxexp);sci2exp(R);sci2exp(Bv);sci2exp(Ibv);sci2exp(Nbv)];
    gr_i=[...
          'if orient then';...
          '  xx=orig(1);yy=orig(2);';...
          '  ww=sz(1);hh=sz(2);';...
          'else';...
          '  xx=orig(1)+sz(1);yy=orig(2);';...
          '  ww=-sz(1);hh=sz(2);';...
          'end';...
          'xpoly(xx+ww*[0.65;0.35;0.35;0.65],yy+hh*[0.5;0.7;0.3;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(255,255,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'xpoly(xx+ww*[0.05;0.7],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'xpoly(xx+ww*[0.7;0.95],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'xpoly(xx+ww*[0.65;0.65],yy+hh*[0.7;0.3]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.135,orig(2)+sz(2)*0.105,""Bv=""+string(Bv)+"""",sz(1)*1.31,sz(2)*0.14,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.135-1.31),orig(2)+sz(2)*0.105,""Bv=""+string(Bv)+"""",sz(1)*1.31,sz(2)*0.14,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,0);';...
          'e.font_foreground=color(0,0,0);';...
          'e.fill_mode=""off"";';...
          'xpoly(xx+ww*[0.65;0.6],yy+hh*[0.3;0.3]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*0.78,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*0.78,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,0);';...
          'e.font_foreground=color(0,0,0);';...
          'e.fill_mode=""off"";';...
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=["fillColor=blue;strokeColor=blue"]
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=["strokeColor=blue"]
  end
endfunction
