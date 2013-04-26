// Coselica Toolbox for Xcos
// Copyright (C) 2013 - Scilab Enterprises - Bruno JOFRET
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

function [x,y,typ]=MEMC_Q2driver(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'set' then
    x=arg1;
  case 'define' then
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Modelica.Electrical.Machines.Components.Q2driver';
      mo.inputs=['pin_p', 'pin_n', 'u'];
      mo.outputs=['pout_p','pout_n'];
      mo.parameters=list([], list(), []);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I', 'I', 'I'];
    x.graphics.in_style=[ElecInputStyle(), ElecOutputStyle(), RealInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[ElecInputStyle(), ElecOutputStyle()];
  end
endfunction
