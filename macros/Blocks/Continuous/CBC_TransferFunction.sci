// Coselica Toolbox for Xcos
// Copyright (C) 2012 - Scilab Enterprises - Bruno JOFRET
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

function [x,y,typ]=CBC_TransferFunction(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,na,nb,b,a,initType,x_start,y_start,exprs]=..
              getvalue(['';'CBC_TransferFunction';'';'Linear transfer function';''],..
                       [' na [-] : Size of Denominator of transfer function.';' nb [-] : Size of Numerator of transfer function.';' b [-] : Numerator coefficients of transfer function (e.g., 2*s+3 is specified as [2,3])';' a [-] : Denominator coefficients of transfer function (e.g., 5*s+6 is specified as [5,6])';' initType [-] : Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)';' x_start [-] : Initial or guess values of states';' y_start [-] : Initial value of output (derivatives of y are zero upto nx-1-th derivative)'],..
                       list('vec',1,'vec',1,'vec',-1,'vec',-1,'vec',1,'vec',-1,'vec',1),exprs);
          if ~ok then break, end
          model.in=[1];
          model.out=[1];
          na=int32(na);
          nb=int32(nb);
          initType=int32(initType);
          model.equations.parameters(2)=list(na,nb,b,a,initType,x_start,y_start)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      na=2;
      nb=1;
      b=1;
      a=[1,1];
      initType=1;
      x_start=0;
      y_start=0;
      exprs=[strcat(sci2exp(na));strcat(sci2exp(nb));strcat(sci2exp(b));strcat(sci2exp(a));strcat(sci2exp(initType));strcat(sci2exp(x_start));strcat(sci2exp(y_start))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Coselica.Blocks.Continuous.TransferFunction';
      mo.inputs=['u'];
      mo.outputs=['y'];
      na=int32(2);
      nb=int32(1);
      initType=int32(1);
      mo.parameters=list(['na','nb','b','a','initType','x_start','y_start'],..
                         list(na,nb,b,a,initType,x_start,y_start),..
                         [0,0,0,0,0,0,0]);
      model.equations=mo;
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
    end
endfunction
