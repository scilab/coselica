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

function [x,y,typ]=CMPF_WorldForce(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    standard_draw(arg1,%f,_CMPF_WorldForce_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPF_WorldForce_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPF_WorldForce_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
  case 'define' then
    exprs=[];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[2];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Forces.WorldForce';
      mo.inputs=['force'];
      mo.outputs=['frame_b'];
      mo.parameters=list([],list(),[]);
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
          '  xstringb(orig(1)+sz(1)*0,orig(2)+sz(2)*0.15,""world"",sz(1)*0.75,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0-0.75),orig(2)+sz(2)*0.15,""world"",sz(1)*0.75,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.font_foreground=color(192,192,192);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0;0.75;0.75;0.97;0.75;0.75;0;0],yy+hh*[0.55;0.55;0.655;0.5;0.345;0.45;0.45;0.55]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.245,orig(2)+sz(2)*0.71,""""+model.label+"""",sz(1)*1.425,sz(2)*0.305,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.245-1.425),orig(2)+sz(2)*0.71,""""+model.label+"""",sz(1)*1.425,sz(2)*0.305,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['E'];
    x.graphics.out_implicit=['I'];
  end
endfunction
