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

function [x,y,typ]=CMTC_Mass(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    m=arg1.graphics.exprs(1);
    initType=arg1.graphics.exprs(2);
    s_start=arg1.graphics.exprs(3);
    v_start=arg1.graphics.exprs(4);
    L=arg1.graphics.exprs(5);
    standard_draw(arg1,%f,_MMTI_Rigid_dp);
  case 'getinputs' then
    [x,y,typ]=_MMTI_Rigid_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MMTI_Rigid_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,m,initType,s_start,v_start,L,exprs]=..
        getvalue(['';'CMTC_Mass';'';'Sliding mass with inertia';''],..
        [' m [kg] : Mass of the sliding mass';' initType [-] : Type of initial value for [s,v] (0=guess,1=fixed)';' s_start [m] : Initial value for absolute position of center of mass';' v_start [m/s] : Initial value for absolute velocity of mass';' L [m] : length of component from left flange to right flange (= flange_b.s - flange_a.s)'],..
        list('vec',1,'vec',2,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(m,initType,s_start,v_start,L)
      model.in=[1];
      model.out=[1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    m=1;
    initType=[0,0];
    s_start=0;
    v_start=0;
    L=0;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Components.Mass';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b'];
      mo.parameters=list(['m','initType','s_start','v_start','L'],..
                         list(m,initType,s_start,v_start,L),..
                         [0,0,0,0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(m));strcat(sci2exp(initType));strcat(sci2exp(s_start));strcat(sci2exp(v_start));strcat(sci2exp(L))];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[TransInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[TransOutputStyle()];
  end
endfunction
