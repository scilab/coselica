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

function [x,y,typ]=CEAB_TranslationalEMF(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    k=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CEAB_TranslationalEM_dp);
  case 'getinputs' then
    [x,y,typ]=_CEAB_TranslationalEM_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CEAB_TranslationalEM_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,k,exprs]=...
        getvalue(['';'CEAB_TranslationalEMF';'';'Electromotoric force (electric/mechanic transformer)';''],...
        [' k [N/A] : Transformation coefficient'],...
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(k)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    k=1;
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Coselica.Electrical.Analog.Basic.TranslationalEMF';
      mo.inputs=['p','support'];
      mo.outputs=['n','flange'];
      mo.parameters=list(['k'],...
                         list(k),...
                         [0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(k)];
    gr_i=[...
          'if orient then';...
          '  xx=orig(1);yy=orig(2);';...
          '  ww=sz(1);hh=sz(2);';...
          'else';...
          '  xx=orig(1)+sz(1);yy=orig(2);';...
          '  ww=-sz(1);hh=sz(2);';...
          'end';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.05,orig(2)+sz(2)*0.755,sz(1)*0.25,sz(2)*0.505);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.05-0.25),orig(2)+sz(2)*0.755,sz(1)*0.25,sz(2)*0.505);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(135,135,135);';...
          'e.background=color(135,135,135);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.395,orig(2)+sz(2)*0.6,sz(1)*0.555,sz(2)*0.2);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.395-0.555),orig(2)+sz(2)*0.6,sz(1)*0.555,sz(2)*0.2);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(135,135,135);';...
          'e.background=color(135,135,135);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*0.5,orig(2)+sz(2)*0.72,""k=""+string(k)+"""",sz(1)*0.74,sz(2)*0.18,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1-0.5-0.74),orig(2)+sz(2)*0.72,""k=""+string(k)+"""",sz(1)*0.74,sz(2)*0.18,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(160,160,164);';...
          'e.background=color(0,0,0);';...
          'e.font_foreground=color(0,0,0);';...
          'e.fill_mode=""off"";';...
          'xpoly(xx+ww*[0.35;0.35;0.5;0.5],yy+hh*[0.745;0.9;0.9;0.955]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'xpoly(xx+ww*[0.6;0.6;0.5;0.5;0.5],yy+hh*[0.255;0.1;0.1;0.055;0.05]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xarc(orig(1)+sz(1)*0.395,orig(2)+sz(2)*0.75,sz(1)*0.15,sz(2)*0.5,0,360*64);';...
          'else';...
          '  xarc(orig(1)+sz(1)*(1-0.395-0.15),orig(2)+sz(2)*0.75,sz(1)*0.15,sz(2)*0.5,0,360*64);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,0);';...
          'e.fill_mode=""off"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xarc(orig(1)+sz(1)*0.51,orig(2)+sz(2)*0.75,sz(1)*0.15,sz(2)*0.5,0,360*64);';...
          'else';...
          '  xarc(orig(1)+sz(1)*(1-0.51-0.15),orig(2)+sz(2)*0.75,sz(1)*0.15,sz(2)*0.5,0,360*64);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,0);';...
          'e.fill_mode=""off"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xarc(orig(1)+sz(1)*0.285,orig(2)+sz(2)*0.75,sz(1)*0.15,sz(2)*0.5,0,360*64);';...
          'else';...
          '  xarc(orig(1)+sz(1)*(1-0.285-0.15),orig(2)+sz(2)*0.75,sz(1)*0.15,sz(2)*0.5,0,360*64);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,0);';...
          'e.fill_mode=""off"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.48,orig(2)+sz(2)*0.6,sz(1)*0.015,sz(2)*0.2);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.48-0.015),orig(2)+sz(2)*0.6,sz(1)*0.015,sz(2)*0.2);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(135,135,135);';...
          'e.background=color(135,135,135);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.535,orig(2)+sz(2)*0.6,sz(1)*0.015,sz(2)*0.2);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.535-0.015),orig(2)+sz(2)*0.6,sz(1)*0.015,sz(2)*0.2);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(135,135,135);';...
          'e.background=color(135,135,135);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.43,orig(2)+sz(2)*0.6,sz(1)*0.015,sz(2)*0.2);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.43-0.015),orig(2)+sz(2)*0.6,sz(1)*0.015,sz(2)*0.2);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(135,135,135);';...
          'e.background=color(135,135,135);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0.595,orig(2)+sz(2)*0.6,sz(1)*0.125,sz(2)*0.2);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0.595-0.125),orig(2)+sz(2)*0.6,sz(1)*0.125,sz(2)*0.2);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(135,135,135);';...
          'e.background=color(135,135,135);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'e.line_style=1;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*0.5,orig(2)+sz(2)*0.05,""""+model.label+"""",sz(1)*0.995,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1-0.5-0.995),orig(2)+sz(2)*0.05,""""+model.label+"""",sz(1)*0.995,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,255);';...
          'e.background=color(0,0,0);';...
          'e.font_foreground=color(0,0,0);';...
          'e.fill_mode=""off"";';...
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.out_implicit=['I','I'];
  end
endfunction
