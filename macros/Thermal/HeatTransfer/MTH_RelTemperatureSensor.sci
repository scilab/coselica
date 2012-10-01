// Coselica Toolbox for Xcos
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
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

function [x,y,typ]=MTH_RelTemperatureSensor(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    standard_draw(arg1,%f,_MTH_HeatFlowSensor_dp);
  case 'getinputs' then
    [x,y,typ]=_MTH_HeatFlowSensor_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MTH_HeatFlowSensor_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
  case 'define' then
    model=scicos_model();
    model.rpar=[];
    model.sim='MTH_RelTemperatureSensor';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MTH_RelTemperatureSensor';
      mo.inputs=['port_a'];
      mo.outputs=['port_b','T_rel'];
      mo.parameters=list([],list(),[]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=string([]);
    gr_i=[""];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style = [ThermalInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[ThermalOutputStyle(), RealOutputStyle()];
  end
endfunction
