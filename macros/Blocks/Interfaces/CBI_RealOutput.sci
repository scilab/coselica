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

function [x,y,typ]=CBI_RealOutput(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    standard_draw(arg1,%f,_CBI_RealOutput_dp);
  case 'getinputs' then
    [x,y,typ]=_CBI_RealOutput_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CBI_RealOutput_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
  case 'define' then
    model=scicos_model();
    model.sim='CBI_RealOutput';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='CBI_RealOutput';
      mo.inputs=['u'];
      mo.outputs=['y'];
      mo.parameters=list([],list(),[]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[];
    gr_i=[...
          'if orient then';...
          '  xx=orig(1);yy=orig(2);';...
          '  ww=sz(1);hh=sz(2);';...
          'else';...
          '  xx=orig(1)+sz(1);yy=orig(2);';...
          '  ww=-sz(1);hh=sz(2);';...
          'end';...
          'xpoly(xx+ww*[0;1;0;0],yy+hh*[1;0.5;0;1]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,191);';...
          'e.background=color(255,255,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*1,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*1,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,255);';...
          'e.fill_mode=""off"";';...
         ];
    x=standard_define([2/3 2/3],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=["strokeColor=blue;fillColor=blue"];
    x.graphics.out_implicit=['E'];
  end
endfunction
