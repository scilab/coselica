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

function [x,y,typ]=CMPJ_Prismatic(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    n=arg1.graphics.exprs(1);
    s_offset=arg1.graphics.exprs(2);
    initType=arg1.graphics.exprs(3);
    s_start=arg1.graphics.exprs(4);
    v_start=arg1.graphics.exprs(5);
    a_start=arg1.graphics.exprs(6);
    standard_draw(arg1,%f,_CMPI_TwoFrames_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPI_TwoFrames_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPI_TwoFrames_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,n,s_offset,initType,s_start,v_start,a_start,exprs]=..
        getvalue(['';'CMPJ_Prismatic';'';'Prismatic joint (1 translational degree-of-freedom, 2 states)';''],..
        [' n [-] : Axis of translation resolved in frame_a (= same as in frame_b)';' s_offset [m] : Relative distance offset (distance between frame_a and frame_b = s_offset + s)';' initType [-] : Type of initial value for [s,v,a] (0=guess,1=fixed)';' s_start [m] : Initial value of distance s';' v_start [m/s] : Initial value of relative velocity v = der(s)';' a_start [m/s2] : Initial value of relative acceleration a = der(v)'],..
        list('vec',2,'vec',1,'vec',3,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[1];
      model.equations.parameters(2)=list(n,s_offset,initType,s_start,v_start,a_start)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    n=[1,0];
    s_offset=0;
    initType=[0,0,0];
    s_start=0;
    v_start=0;
    a_start=0;
    exprs=[strcat(sci2exp(n));strcat(sci2exp(s_offset));strcat(sci2exp(initType));strcat(sci2exp(s_start));strcat(sci2exp(v_start));strcat(sci2exp(a_start))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Joints.Prismatic';
      mo.inputs=['frame_a'];
      mo.outputs=['frame_b'];
      mo.parameters=list(['n','s_offset','initType','s_start','v_start','a_start'],..
                         list(n,s_offset,initType,s_start,v_start,a_start),..
                         [0,0,0,0,0,0]);
    model.equations=mo;
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[PlanInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[PlanOutputStyle()];
  end
endfunction
