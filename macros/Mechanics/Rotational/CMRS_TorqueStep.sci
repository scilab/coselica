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

function [x,y,typ]=CMRS_TorqueStep(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,stepTorque,offsetTorque,startTime,exprs]=..
              getvalue(['CMRS_TorqueStep';__('Constant torque, not dependent on speed')],..
                       [__('stepTorque [N.m] : Height of torque step (if negative, torque is acting as load)');...
                        __('offsetTorque [N.m] : Offset of torque');...
                        __('startTime [s] : Torque = offset for time < startTime')],..
                       list('vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(stepTorque,offsetTorque,startTime)
          model.in=[];
          model.out=[1;1];
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      stepTorque=1;
      offsetTorque=0;
      startTime=0;
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[];
      model.out=[1;1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Rotational.Sources.TorqueStep';
      mo.inputs=[];
      mo.outputs=['flange','support'];
      mo.parameters=list(['stepTorque','offsetTorque','startTime'],..
                         list(stepTorque,offsetTorque,startTime),..
                         [0,0,0]);
      model.equations=mo;
      exprs=[strcat(sci2exp(stepTorque));strcat(sci2exp(offsetTorque));strcat(sci2exp(startTime))];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[RotOutputStyle() ; RotOutputStyle()];
    end
endfunction
