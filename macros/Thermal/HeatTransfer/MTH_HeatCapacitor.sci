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

function [x,y,typ]=MTH_HeatCapacitor(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,C,steadyStateStart,T_start,exprs]=...
              getvalue(['MTH_HeatCapacitor';__('Lumped thermal element storing heat')],...
                       [__('C [J/K] : Heat capacity of part (= cp*m)');...
                        __('steadyStateStart [-] : true, if component shall start in steady state');...
                        __('T_start [K] : Initial temperature of part (in Kelvin)')],...
                       list('vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.rpar=[C,steadyStateStart,T_start];
          model.equations.parameters(2)=list(C,steadyStateStart,T_start)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      C=1;
      steadyStateStart=0;
      T_start=293.15;
      model.rpar=[C;steadyStateStart;T_start];
      model.sim='MTH_HeatCapacitor';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='MTH_HeatCapacitor';
      mo.inputs=[];
      mo.outputs=['port'];
      mo.parameters=list(['C','steadyStateStart','T_start'],...
                         list(C,steadyStateStart,T_start),...
                         [0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=string([C;steadyStateStart;T_start]);
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ThermalOutputStyle()];
    end
endfunction
