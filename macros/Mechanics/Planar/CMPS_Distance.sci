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

function [x,y,typ]=CMPS_Distance(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    s_small=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CMPS_Distance_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPS_Distance_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPS_Distance_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,s_small,exprs]=..
        getvalue(['';'CMPS_Distance';'';'Measure the distance between the origins of two frame connectors';''],..
        [' s_small [m] : Prevent zero-division if distance between frame_a and frame_b is zero (s_small > 0)'],..
        list('vec',1),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[1;1];
      model.equations.parameters(2)=list(s_small)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    s_small=1.000D-10;
    exprs=[strcat(sci2exp(s_small))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1;1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Sensors.Distance';
      mo.inputs=['frame_a'];
      mo.outputs=['frame_b','distance'];
      mo.parameters=list(['s_small'],..
                         list(s_small),..
                         [0]);
    model.equations=mo;
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[PlanInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[PlanOutputStyle(), RealOutputStyle()];
  end
endfunction
