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

function [x,y,typ]=CMTS_Force2(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    standard_draw(arg1,%f,_CMTS_Force2_dp);
  case 'getinputs' then
    [x,y,typ]=_CMTS_Force2_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMTS_Force2_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
  case 'define' then
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1;1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Sources.Force2';
      mo.inputs=['flange_a','f'];
      mo.outputs=['flange_b'];
      mo.parameters=list([],list(),[]);
    model.equations=mo;
    exprs=[];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0,orig(2)+sz(2)*0,""""+model.label+"""",sz(1)*1,sz(2)*0.3,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*0,""""+model.label+"""",sz(1)*1,sz(2)*0.3,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.95;0.8;0.8;0.55;0.55;0.8;0.8;0.95],yy+hh*[0.5;0.35;0.45;0.45;0.55;0.55;0.655;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,127,0);';
          'e.background=color(215,215,215);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.05;0.2;0.2;0.45;0.45;0.2;0.2;0.05],yy+hh*[0.5;0.65;0.55;0.55;0.45;0.45;0.35;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,127,0);';
          'e.background=color(215,215,215);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.out_implicit=['I'];
    x.graphics.in_style=['fillColor=green;strokeColor=green', 'fillColor=green;strokeColor=green'];
    x.graphics.out_style=['fillColor=white;strokeColor=green'];
end
endfunction
