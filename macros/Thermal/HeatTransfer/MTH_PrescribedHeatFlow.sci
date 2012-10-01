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

function [x,y,typ]=MTH_PrescribedHeatFlow(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    T_ref=arg1.graphics.exprs(1);
    alpha=arg1.graphics.exprs(2);
    standard_draw(arg1,%f,_MTH_PrescribedTemp_dp);
  case 'getinputs' then
    [x,y,typ]=_MTH_PrescribedTemp_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MTH_PrescribedTemp_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,T_ref,alpha,exprs]=...
        getvalue(['';'MTH_PrescribedHeatFlow';'';'Prescribed heat flow boundary condition';''],...
        [' T_ref [K] : Reference temperature';' alpha [1/K] : Temperature coefficient of heat flow rate'],...
        list('vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.rpar=[T_ref,alpha];
      model.equations.parameters(2)=list(T_ref,alpha)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    T_ref=293.15;
    alpha=0;
    model.rpar=[T_ref;alpha];
    model.sim='MTH_PrescribedHeatFlow';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MTH_PrescribedHeatFlow';
      mo.inputs=['Q_flow'];
      mo.outputs=['port'];
      mo.parameters=list(['T_ref','alpha'],...
                         list(T_ref,alpha),...
                         [0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=string([T_ref;alpha]);
    gr_i=[""];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[RealInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style = [ThermalOutputStyle()];
  end
endfunction
