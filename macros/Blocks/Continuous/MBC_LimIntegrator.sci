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

function [x,y,typ]=MBC_LimIntegrator(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,k,outMax,outMin,y_start,exprs]=..
              getvalue(['MBC_LimIntegrator';__('Integrator with limited values of the outputs')],..
                       [__('k [-] : Integrator gains');...
                        __('outMax [-] : Upper limits of outputs');...
                        __('outMin [-] : Lower limits of outputs');...
                        __('y_start [-] : Start values of integrators')],..
                       list('vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.in=[1];
          model.out=[1];
          model.equations.parameters(2)=list(k,outMax,outMin,y_start)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      k=1;
      outMax=1;
      outMin=-1;
      y_start=0;
      exprs=[strcat(sci2exp(k));strcat(sci2exp(outMax));strcat(sci2exp(outMin));strcat(sci2exp(y_start))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Modelica.Blocks.Continuous.LimIntegrator';
      mo.inputs=['u'];
      mo.outputs=['y'];
      mo.parameters=list(['k','outMax','outMin','y_start'],..
                         list(k,outMax,outMin,y_start),..
                         [0,0,0,0]);
      model.equations=mo;
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
    end
endfunction
