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

function [x,y,typ]=CMPJ_RollingWheel(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    n=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CMPJ_RollingWheel_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPJ_RollingWheel_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPJ_RollingWheel_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,n,exprs]=..
        getvalue(['';'CMPJ_RollingWheel';'';'Joint that describes an ideal rolling wheel (1 non-holonomic constraint, no states)';''],..
        [' n [-] : Wheel axis resolved in frame_a'],..
        list('vec',2),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[];
      model.equations.parameters(2)=list(n)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    n=[0,1];
    exprs=[strcat(sci2exp(n))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Joints.RollingWheel';
      mo.inputs=['frame_a'];
      mo.outputs=[];
      mo.parameters=list(['n'],..
                         list(n),..
                         [0]);
    model.equations=mo;
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[PlanInputStyle()];
    x.graphics.out_implicit=[];
  end
endfunction
