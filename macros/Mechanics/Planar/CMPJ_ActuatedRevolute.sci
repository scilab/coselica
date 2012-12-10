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

function [x,y,typ]=CMPJ_ActuatedRevolute(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,phi_offset,initType,phi_start,w_start,z_start,exprs]=..
              getvalue(['';'CMPJ_ActuatedRevolute';'';'Actuated revolute joint (1 rotational degree-of-freedom, 2 states)';''],..
                       [' phi_offset [rad] : Relative angle offset (angle = phi + phi_offset)';' initType [-] : Type of initial value for [phi,w,z] (0=guess,1=fixed)';' phi_start [rad] : Initial value of rotation angle phi';' w_start [rad/s] : Initial value of relative angular velocity w = der(phi)';' z_start [rad/s2] : Initial value of relative angular acceleration z = der(w)'],...
                       list('vec',1,'vec',3,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.in=[1;1];
          model.out=[1;1];
          model.equations.parameters(2)=list(phi_offset,initType,phi_start,w_start,z_start)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      phi_offset=0;
      initType=[0,0,0];
      phi_start=0;
      w_start=0;
      z_start=0;
      exprs=[strcat(sci2exp(phi_offset));strcat(sci2exp(initType));strcat(sci2exp(phi_start));strcat(sci2exp(w_start));strcat(sci2exp(z_start))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1;1];
      model.out=[1;1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Joints.ActuatedRevolute';
      mo.inputs=['frame_a','bearing'];
      mo.outputs=['frame_b','axis'];
      mo.parameters=list(['phi_offset','initType','phi_start','w_start','z_start'],..
                         list(phi_offset,initType,phi_start,w_start,z_start),..
                         [0,0,0,0,0]);
      model.equations=mo;
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[PlanInputStyle(), RotInputStyle()];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[PlanOutputStyle(), RotOutputStyle()];
    end
endfunction
