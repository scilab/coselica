// Coselica Toolbox for Xcos
// Copyright (C) 2012 - Scilab Enterprises - Bruno JOFRET
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

function [x,y,typ]=CBS_Trapezoid(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,amplitude,rising,width,falling,period,nperiod,offset,startTime,exprs]=...
              scicos_getvalue(['CBS_Trapezoid';__('Generate trapezoidal signal')],...
                              [__('amplitude [-] : Amplitude of trapezoid');...
                    __('rising [s] : Rising duration of trapezoid');...
                    __('width [s] : Width duration of trapezoid');...
                    __('falling [s] : Falling duration of trapezoid');...
                    __('period [s] : Time for one period');...
                    __('nperiod [-] : Number of periods (< 0 means infinite number of periods)');...
                    __('offset [-] : Offset of output signal');...
                    __('startTime [s] : Output = offset for time < startTime')],...
                              list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then
              break
          end

          // Check if all time values are positive.
          if rising < 0 then
               message(__("Rising duration of trapezoid must be positive."));
               ok = %f;
          end

          if width < 0 then
              message(__("Width duration of trapezoid must be positive."));
              ok = %f;
          end

          if falling < 0 then
              message(__("Falling duration of trapezoid must be positive."));
              ok = %f;
          end

          if period < 0 then
              message(__("Time for one period must be positive."));
              ok = %f;
          end

          // Period time must be greater than Rising + Width + Falling
          if period < rising + width + falling
              message(__("Period must be greater than Rising + Width + Falling"));
              ok = %f;
          end

          if int(nperiod) <> nperiod then
              message(__("Numbre of periods must be an integer value."));
              ok = %f;
          end

          if ok then
              model.equations.parameters(2)=list(amplitude,rising,width,falling,period,nperiod,offset,startTime)
              graphics.exprs=exprs;
              x.graphics=graphics;x.model=model;
              break
          end
      end
     case 'define' then
      model=scicos_model();
      amplitude=1;
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
      mo.model='Coselica.Blocks.Sources.Trapezoid';
      mo.inputs=[];
      mo.outputs=['y'];
      mo.parameters=list(['amplitude','rising','width','falling','period','nperiod','offset','startTime'],...
                         list(amplitude,rising,width,falling,period,nperiod,offset,startTime),...
                         [0,0,0,0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(amplitude);sci2exp(rising);sci2exp(width);sci2exp(falling);sci2exp(period);sci2exp(nperiod);sci2exp(offset);sci2exp(startTime)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
    end
endfunction
