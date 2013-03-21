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

function [x,y,typ]=MBC_PID(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,k,Ti,Td,Nd,exprs]=..
              getvalue(['MBC_PID';__('PID-controller in additive description form')],..
                       [__('k [-] : Gain');...
                        __('Ti [s] : Time Constant of Integrator block');...
                        __('Td [s] : Time Constant of Derivative block');...
                        __('Nd [-] : The higher Nd, the more ideal the Derivative block')],..
                       list('vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.in=[1];
          model.out=[1];
          model.equations.parameters(2)=list(k,Ti,Td,Nd)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      k=1;
      Ti=0.5;
      Td=0.1;
      Nd=10;
      exprs=[strcat(sci2exp(k));strcat(sci2exp(Ti));strcat(sci2exp(Td));strcat(sci2exp(Nd))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Modelica.Blocks.Continuous.PID';
      mo.inputs=['u'];
      mo.outputs=['y'];
      mo.parameters=list(['k','Ti','Td','Nd'],..
                         list(k,Ti,Td,Nd),..
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
