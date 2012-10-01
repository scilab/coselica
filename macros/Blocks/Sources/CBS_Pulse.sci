// Coselica Toolbox for Xcos
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
// Copyright (C) 2009, 2010  Dirk Reusch, Kybernetik Dr. Reusch
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

function [x,y,typ]=CBS_Pulse(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    amplitude=arg1.graphics.exprs(1);
    width=arg1.graphics.exprs(2);
    period=arg1.graphics.exprs(3);
    offset=arg1.graphics.exprs(4);
    startTime=arg1.graphics.exprs(5);
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
      [ok,amplitude,width,period,offset,startTime,exprs]=...
        getvalue(['';'CBS_Pulse';'';'Generate pulse signal of type Real';''],...
        [' amplitude [-] : Amplitude of pulse';' width [-] : Width of pulse in % of period';' period [s] : Time for one period';' offset [-] : Offset of output signals';' startTime [s] : Output = offset for time < startTime'],...
        list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(amplitude,width,period,offset,startTime)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    amplitude=1;
    width=50;
    period=1;
    offset=0;
    startTime=0;
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Coselica.Blocks.Sources.Pulse';
      mo.inputs=[];
      mo.outputs=['y'];
      mo.parameters=list(['amplitude','width','period','offset','startTime'],...
                         list(amplitude,width,period,offset,startTime),...
                         [0,0,0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(amplitude);sci2exp(width);sci2exp(period);sci2exp(offset);sci2exp(startTime)];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=[];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RealOutputStyle()];
  end
endfunction
