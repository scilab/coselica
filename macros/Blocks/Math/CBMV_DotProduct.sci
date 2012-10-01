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

function [x,y,typ]=CBMV_DotProduct(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    n=arg1.graphics.exprs(1);
    n=strcat(sci2exp(double(evstr(n))));
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
      [ok,n,exprs]=..
        getvalue(['';'CBMV_DotProduct';'';'Outputs the dot product of two input signal vectors';''],..
        [' n [-] : Dimension of input vectors.'],..
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(n)
      n=double(n);
      model.in=[n;n];
      model.out=[1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    n=1;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[n;n];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Blocks.Math.Vectors.DotProduct';
      mo.inputs=['u1','u2'];
      mo.outputs=['y'];
      mo.parameters=list(['n'],..
                         list(n),..
                         [0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(n))];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.in_style=[RealInputStyle(), RealInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RealOutputStyle()];
  end
endfunction
