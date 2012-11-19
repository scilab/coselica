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

function [x,y,typ]=MTH_FixedTemperature(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,T,exprs]=...
              getvalue(['';'MTH_FixedTemperature';'';'Fixed temperature boundary condition in Kelvin';''],...
                       [' T [K] : Fixed temperature at port'],...
                       list('vec',1),exprs);
          if ~ok then break, end
          model.rpar=[T];
          model.equations.parameters(2)=list(T)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      T=1;
      model.rpar=[T];
      model.sim='MTH_FixedTemperature';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='MTH_FixedTemperature';
      mo.inputs=[];
      mo.outputs=['port'];
      mo.parameters=list(['T'],...
                         list(T),...
                         [0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=string([T]);
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ThermalOutputStyle()];
    end
endfunction
