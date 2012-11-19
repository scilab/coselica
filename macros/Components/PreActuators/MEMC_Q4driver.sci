// Coselica Toolbox for Xcos
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
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

function [x,y,typ]=MEMC_Q4driver(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
//    k=arg1.graphics.exprs(1);
//    standard_draw(arg1,%f,_CEAB_EMF_dp);
  case 'getinputs' then
//    [x,y,typ]=_CEAB_EMF_ip(arg1);
  case 'getoutputs' then
//    [x,y,typ]=_CEAB_EMF_op(arg1);
  case 'getorigin' then
//    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,U,exprs]=...
        getvalue(['';'MEMC_Q4driver';'';'quadruple half-h driver';''],...
        [' U (V): supply voltage'] ,...
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(U)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    U=12;
    mo=modelica();
      mo.model='Modelica.Electrical.Machines.Components.Q4driver';
      mo.inputs=['com1','com2'];
      mo.outputs=['p','n'];
      mo.parameters=list(['U'],...
                         list(U),...
                         [0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(U)];

    x=standard_define([2 2],model,exprs,[]);
    x.graphics.in_implicit=['I','I'];
    x.graphics.in_style=[RealInputStyle(),RealInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[ElecInputStyle(), ElecOutputStyle()];
  end
endfunction
