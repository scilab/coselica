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

function [x,y,typ]=MBS_Constant(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    k=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_MBI_SO_dp);
  case 'getinputs' then
    [x,y,typ]=_MBI_SO_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MBI_SO_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,k,exprs]=...
        getvalue(['';'MBS_Constant';'';'Generate constant signal of type Real';''],...
        [' k [-] : Constant output value'],...
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
    model.sim='MBS_Constant';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MBS_Constant';
      mo.inputs=[];
      mo.outputs=['y'];
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
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,191);';...
          'e.background=color(255,255,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,255);';...
          'e.fill_mode=""off"";';...
          'xpoly(xx+ww*[0.1;0.1],yy+hh*[0.84;0.1]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.1;0.06;0.14;0.1],yy+hh*[0.95;0.84;0.84;0.95]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.background=color(192,192,192);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.05;0.91],yy+hh*[0.15;0.15]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.95;0.84;0.84;0.95],yy+hh*[0.15;0.19;0.11;0.15]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.background=color(192,192,192);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.1;0.9],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*-0.25,""k=""+string(k)+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*-0.25,""k=""+string(k)+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,0);';...
          'e.fill_mode=""off"";';...
         ];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=[];
    x.graphics.out_implicit=['E'];
  end
endfunction
