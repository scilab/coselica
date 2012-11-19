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

function [x,y,typ]=CBMV_ElementwiseProduct(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,n,exprs]=..
              getvalue(['';'CBMV_ElementwiseProduct';'';'Outputs the element-wise product of two input signal vectors';''],..
                       [' n [-] : Dimension of input and output vectors.'],..
                       list('vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(n)
          n=double(n);
          model.in=[n;n];
          model.out=[n];
          //model.intyp=[1,1];
          //model.outtyp=[1];
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
      model.out=[n];
      //model.intyp=[1,1];
      //model.outtyp=[1];
      mo=modelica();
      mo.model='Coselica.Blocks.Math.Vectors.ElementwiseProduct';
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
