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

function [x,y,typ]=CMRC_IdealDifferential(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    ratio=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CMRC_Differential_dp);
  case 'getinputs' then
    [x,y,typ]=_CMRC_Differential_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMRC_Differential_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,ratio,exprs]=..
        getvalue(['';'CMRC_IdealDifferential';'';'Ideal differential gear without inertia';''],..
        [' ratio [-] : Transmission ratio (2*flange_a.phi/(flange_left.phi+flange_right.phi))'],..
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(ratio)
      model.in=[1];
      model.out=[1;1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    ratio=1;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1;1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Rotational.Components.IdealDifferential';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_left','flange_right'];
      mo.parameters=list(['ratio'],..
                         list(ratio),..
                         [0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(ratio))];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*0.55,sz(1)*0.25,sz(2)*0.1);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-0.25),orig(2)+sz(2)*0.55,sz(1)*0.25,sz(2)*0.1);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.75,orig(2)+sz(2)*0.55,sz(1)*0.25,sz(2)*0.1);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.75-0.25),orig(2)+sz(2)*0.55,sz(1)*0.25,sz(2)*0.1);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
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
          'e.line_style=1;';
          'xpoly(xx+ww*[0.25;0.25;0.75;0.75;0.625;0.375;0.25],yy+hh*[0.375;0.625;0.625;0.375;0.25;0.25;0.375]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*0.675,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*0.675,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.65,orig(2)+sz(2)*0.1,""ratio=""+string(ratio)+"""",sz(1)*0.85,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.65-0.85),orig(2)+sz(2)*0.1,""ratio=""+string(ratio)+"""",sz(1)*0.85,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I','I'];
  end
endfunction
