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

function [x,y,typ]=MBM_Add(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    k1=arg1.graphics.exprs(1);
    k2=arg1.graphics.exprs(2);
    standard_draw(arg1,%f,_MBI_SI2SO_dp);
  case 'getinputs' then
    [x,y,typ]=_MBI_SI2SO_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MBI_SI2SO_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,k1,k2,exprs]=..
        getvalue(['';'MBM_Add';'';'Output the sum of the two inputs';''],..
        [' k1 [-] : Gain of upper input';' k2 [-] : Gain of lower input'],..
        list('vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(k1,k2)
      model.in=[1;1];
      model.out=[1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    k1=1;
    k2=1;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1;1];
    model.out=[1];
    mo=modelica();
      mo.model='Modelica.Blocks.Math.Add';
      mo.inputs=['u1','u2'];
      mo.outputs=['y'];
      mo.parameters=list(['k1','k2'],..
                         list(k1,k2),..
                         [0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(k1));strcat(sci2exp(k2))];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.in_style=[RealInputStyle(), RealInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RealOutputStyle()];
  end
endfunction
