// Coselica Toolbox for Xcos
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
// Copyright (C) 2009  Dirk Reusch, Kybernetik Dr. Reusch
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

function [x,y,typ]=MBS_Exponentials(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    outMax=arg1.graphics.exprs(1);
    riseTime=arg1.graphics.exprs(2);
    riseTimeConst=arg1.graphics.exprs(3);
    fallTimeConst=arg1.graphics.exprs(4);
    offset=arg1.graphics.exprs(5);
    startTime=arg1.graphics.exprs(6);
    standard_draw(arg1,%f,_MBI_SO_dp);
  case 'getinputs' then
    [x,y,typ]=_MBI_SO_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MBI_SO_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,outMax,riseTime,riseTimeConst,fallTimeConst,offset,startTime,exprs]=...
        scicos_getvalue(['';'MBS_Exponentials';'';'Generate a rising and falling exponential signal';''],...
        [' outMax [-] : Height of output for infinite riseTime';' riseTime [s] : Rise time';' riseTimeConst [s] : Rise time constant';' fallTimeConst [s] : Fall time constant';' offset [-] : Offset of output signal';' startTime [s] : Output = offset for time < startTime'],...
        list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(outMax,riseTime,riseTimeConst,fallTimeConst,offset,startTime)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    outMax=1;
    riseTime=0.5;
    riseTimeConst=0.1;
    fallTimeConst=0.5;
    offset=0;
    startTime=0;
    model.sim='MBS_Exponentials';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MBS_Exponentials';
      mo.inputs=[];
      mo.outputs=['y'];
      mo.parameters=list(['outMax','riseTime','riseTimeConst','fallTimeConst','offset','startTime'],...
                         list(outMax,riseTime,riseTimeConst,fallTimeConst,offset,startTime),...
                         [0,0,0,0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(outMax); sci2exp(riseTime); sci2exp(riseTimeConst); ...
           sci2exp(fallTimeConst); sci2exp(offset); sci2exp(startTime)];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=[];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RealOutputStyle()];
  end
endfunction
