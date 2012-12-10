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

function [x,y,typ]=CEAS_TrapezoidCurrent(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,I,rising,width,falling,period,nperiod,offset,startTime,exprs]=...
              getvalue(['';'CEAS_TrapezoidCurrent';'';'Trapezoidal current source';''],...
                       [' I [A] : Amplitude of trapezoid';' rising [s] : Rising duration of trapezoid (>=0)';' width [s] : Width duration of trapezoid (>=0)';' falling [s] : Falling duration of trapezoid (>=0)';' period [s] : Time for one period (>0)';' nperiod [-] : Number of periods (< 0 means infinite number of periods)';' offset [A] : Current offset';' startTime [s] : Time offset'],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(I,rising,width,falling,period,nperiod,offset,startTime)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      I=1;
      rising=0;
      width=0.5;
      falling=0;
      period=1;
      nperiod=-1;
      offset=0;
      startTime=0;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Coselica.Electrical.Analog.Sources.TrapezoidCurrent';
      mo.inputs=['p'];
      mo.outputs=['n'];
      mo.parameters=list(['I','rising','width','falling','period','nperiod','offset','startTime'],...
                         list(I,rising,width,falling,period,nperiod,offset,startTime),...
                         [0,0,0,0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(I);sci2exp(rising);sci2exp(width);sci2exp(falling);sci2exp(period);sci2exp(nperiod);sci2exp(offset);sci2exp(startTime)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[ElecInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ElecOutputStyle()];
    end
endfunction
