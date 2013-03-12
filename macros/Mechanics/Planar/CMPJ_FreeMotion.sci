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

function [x,y,typ]=CMPJ_FreeMotion(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,initType,r_rel_a_start,v_rel_a_start,a_rel_a_start,phi_rel_start,w_rel_start,z_rel_start,exprs]=..
              getvalue(['CMPJ_FreeMotion';__('Free motion joint (3 degrees-of-freedom, 6 states)')],..
                       [__('initType [-] : Type of initial value for [r_rel_a,v_rel_a,a_rel_a,phi_rel,w_rel,z_rel] (0=guess,1=fixed)'); ...
                        __('r_rel_a_start [m] : Initial values of r_rel_a (vector from origin of frame_a to origin of frame_b resolved in frame_a)'); ...
                        __('v_rel_a_start [m/s] : Initial values of velocity v_rel_a = der(r_rel_a)'); ...
                        __('a_rel_a_start [m/s2] : Initial values of acceleration a_rel_a = der(v_rel_a)');...
                        __('phi_rel_start [rad] : Initial value of angle phi_rel to rotate frame_a into frame_b');..
                        __('w_rel_start [rad/s] : Initial value of angular velocity w_rel = der(phi_rel) of frame_b with respect to frame_a'); ..
                        __('z_rel_start [rad/s2] : Initial value of angular acceleration z_rel = der(w_rel) of frame_b with respect to frame_a')],..
                       list('vec',6,'vec',2,'vec',2,'vec',2,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.in=[1];
          model.out=[1];
          model.equations.parameters(2)=list(initType,r_rel_a_start,v_rel_a_start,a_rel_a_start,phi_rel_start,w_rel_start,z_rel_start)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      initType=[0,0,0,0,0,0];
      r_rel_a_start=[0,0];
      v_rel_a_start=[0,0];
      a_rel_a_start=[0,0];
      phi_rel_start=0;
      w_rel_start=0;
      z_rel_start=0;
      exprs=[strcat(sci2exp(initType));strcat(sci2exp(r_rel_a_start));strcat(sci2exp(v_rel_a_start));strcat(sci2exp(a_rel_a_start));strcat(sci2exp(phi_rel_start));strcat(sci2exp(w_rel_start));strcat(sci2exp(z_rel_start))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Joints.FreeMotion';
      mo.inputs=['frame_a'];
      mo.outputs=['frame_b'];
      mo.parameters=list(['initType','r_rel_a_start','v_rel_a_start','a_rel_a_start','phi_rel_start','w_rel_start','z_rel_start'],..
                         list(initType,r_rel_a_start,v_rel_a_start,a_rel_a_start,phi_rel_start,w_rel_start,z_rel_start),..
                         [0,0,0,0,0,0,0]);
      model.equations=mo;
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[PlanInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[PlanOutputStyle()];
    end
endfunction
