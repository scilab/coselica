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

function [x,y,typ]=MBC_LimPID(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,k,Ti,Td,yMax,yMin,wp,wd,Ni,Nd,exprs]=..
              getvalue(['';'MBC_LimPID';'';'PID controller with limited output, anti-windup compensation and setpoint weighting';''],..
                       [' k [-] : Gain of PID block';' Ti [s] : Time constant of Integrator block';' Td [s] : Time constant of Derivative block';' yMax [-] : Upper limit of output';' yMin [-] : Lower limit of output';' wp [-] : Set-point weight for Proportional block (0..1)';' wd [-] : Set-point weight for Derivative block (0..1)';' Ni [-] : Ni*Ti is time constant of anti-windup compensation';' Nd [-] : The higher Nd, the more ideal the derivative block'],..
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.in=[1;1];
          model.out=[1];
          model.equations.parameters(2)=list(k,Ti,Td,yMax,yMin,wp,wd,Ni,Nd)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      k=1;
      Ti=0.5;
      Td=0.1;
      yMax=1;
      yMin=-1;
      wp=1;
      wd=0;
      Ni=0.9;
      Nd=10;
      exprs=[strcat(sci2exp(k));strcat(sci2exp(Ti));strcat(sci2exp(Td));strcat(sci2exp(yMax));strcat(sci2exp(yMin));strcat(sci2exp(wp));strcat(sci2exp(wd));strcat(sci2exp(Ni));strcat(sci2exp(Nd))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1;1];
      model.out=[1];
      mo=modelica();
      mo.model='Modelica.Blocks.Continuous.LimPID';
      mo.inputs=['u_s','u_m'];
      mo.outputs=['y'];
      mo.parameters=list(['k','Ti','Td','yMax','yMin','wp','wd','Ni','Nd'],..
                         list(k,Ti,Td,yMax,yMin,wp,wd,Ni,Nd),..
                         [0,0,0,0,0,0,0,0,0]);
      model.equations=mo;
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[RealInputStyle(), RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
    end
endfunction
