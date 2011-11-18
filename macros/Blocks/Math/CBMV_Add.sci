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

function [x,y,typ]=CBMV_Add(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    k1=arg1.graphics.exprs(1);
    k2=arg1.graphics.exprs(2);
    n=arg1.graphics.exprs(3);
    n=strcat(sci2exp(double(evstr(n))));
    standard_draw(arg1,%f,_MBI_SI2SO_dp);
  case 'getinputs' then
    [x,y,typ]=_MBI_SI2SO_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MBI_SI2SO_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,k1,k2,n,exprs]=..
        getvalue(['';'CBMV_Add';'';'Outputs the addition of two input signal vectors';''],..
        [' k1 [-] : Gain of upper input';' k2 [-] : Gain of lower input';' n [-] : Dimension of input and output vectors.'],..
        list('vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(k1,k2,n)
      n=double(n);
      model.in=[n;n];
      model.out=[n];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    k1=1;
    k2=1;
    n=1;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[n;n];
    model.out=[n];
    mo=modelica();
      mo.model='Coselica.Blocks.Math.Vectors.Add';
      mo.inputs=['u1','u2'];
      mo.outputs=['y'];
      mo.parameters=list(['k1','k2','n'],..
                         list(k1,k2,n),..
                         [0,0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(k1));strcat(sci2exp(k2));strcat(sci2exp(n))];
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
          'xpoly(xx+ww*[0.75;1],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0;0.13;0.28],yy+hh*[0.8;0.62;0.62]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0;0.13;0.29],yy+hh*[0.2;0.36;0.36]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.25,orig(2)+sz(2)*0.75,sz(1)*0.5,sz(2)*0.5,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.25-0.5),orig(2)+sz(2)*0.75,sz(1)*0.5,sz(2)*0.5,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""off"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.3,orig(2)+sz(2)*0.7,sz(1)*0.4,sz(2)*0.4,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.3-0.4),orig(2)+sz(2)*0.7,sz(1)*0.4,sz(2)*0.4,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""off"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.75;1],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.31,orig(2)+sz(2)*0.33,""+"",sz(1)*0.38,sz(2)*0.34,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.31-0.38),orig(2)+sz(2)*0.33,""+"",sz(1)*0.38,sz(2)*0.34,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0,orig(2)+sz(2)*0.76,""""+string(k1)+"""",sz(1)*0.525,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0-0.525),orig(2)+sz(2)*0.76,""""+string(k1)+"""",sz(1)*0.525,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0,orig(2)+sz(2)*0.04,""""+string(k2)+"""",sz(1)*0.525,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0-0.525),orig(2)+sz(2)*0.04,""""+string(k2)+"""",sz(1)*0.525,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.in_style=[RealInputStyle(), RealInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RealOutputStyle()];
  end
endfunction
