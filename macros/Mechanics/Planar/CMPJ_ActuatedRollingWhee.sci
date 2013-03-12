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

function [x,y,typ]=CMPJ_ActuatedRollingWhee(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,radius,n,exprs]=..
              getvalue(['CMPJ_ActuatedRollingWhee';__('Joint that describes an ideal actuated rolling wheel (1 non-holonomic constraint, no states)')],..
                       [__('radius [m] : Radius of wheel');...
                        __('n [-] : Wheel axis resolved in frame_a')],..
                       list('vec',1,'vec',2),exprs);
          if ~ok then break, end
          model.in=[1;1];
          model.out=[1];
          model.equations.parameters(2)=list(radius,n)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      radius=1;
      n=[0,1];
      exprs=[strcat(sci2exp(radius));strcat(sci2exp(n))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1;1];
      model.out=[1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Joints.ActuatedRollingWheel';
      mo.inputs=['frame_a','bearing'];
      mo.outputs=['axis'];
      mo.parameters=list(['radius','n'],..
                         list(radius,n),..
                         [0,0]);
      model.equations=mo;
      x=standard_define([2 2],model,exprs,list([],0));
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[PlanInputStyle(), RotInputStyle()]
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RotOutputStyle()];
    end
endfunction
