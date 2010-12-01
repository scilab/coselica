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

function [x,y,typ]=MEAB_VCV(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    gain=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_MEAI_TwoPort_dp);
  case 'getinputs' then
    [x,y,typ]=_MEAI_TwoPort_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MEAI_TwoPort_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,gain,exprs]=...
        getvalue(['';'MEAB_VCV';'';'Linear voltage-controlled voltage source';''],...
        [' gain [-] : Voltage gain'],...
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(gain)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    gain=1;
    model.sim='MEAB_VCV';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MEAB_VCV';
      mo.inputs=['p1','n1'];
      mo.outputs=['p2','n2'];
      mo.parameters=list(['gain'],...
                         list(gain),...
                         [0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(gain)];
    gr_i=[...
          'if orient then';...
          '  xx=orig(1);yy=orig(2);';...
          '  ww=sz(1);hh=sz(2);';...
          'else';...
          '  xx=orig(1)+sz(1);yy=orig(2);';...
          '  ww=-sz(1);hh=sz(2);';...
          'end';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.15,orig(2)+sz(2)*0.85,sz(1)*0.7,sz(2)*0.7);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.15-0.7),orig(2)+sz(2)*0.85,sz(1)*0.7,sz(2)*0.7);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(255,255,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*0.005,orig(2)+sz(2)*-0.145,""""+model.label+"""",sz(1)*0.995,sz(2)*0.25,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1-0.005-0.995),orig(2)+sz(2)*-0.145,""""+model.label+"""",sz(1)*0.995,sz(2)*0.25,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,255);';...
          'e.fill_mode=""off"";';...
          'xpoly(xx+ww*[0.05;0.35],yy+hh*[0.75;0.75]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.35;0.05],yy+hh*[0.25;0.25]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[1;0.65;0.65;1],yy+hh*[0.75;0.75;0.25;0.25]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xarc(orig(1)+sz(1)*0.55,orig(2)+sz(2)*0.6,sz(1)*0.2,sz(2)*0.2,0,360*64);';...
          'else';...
          '  xarc(orig(1)+sz(1)*(1-0.55-0.2),orig(2)+sz(2)*0.6,sz(1)*0.2,sz(2)*0.2,0,360*64);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,0);';...
          'e.fill_mode=""off"";';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.4;0.6],yy+hh*[0.8;0.8]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.6;0.55;0.55;0.6],yy+hh*[0.8;0.815;0.785;0.8]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
         ];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.out_implicit=['I','I'];
  end
endfunction
