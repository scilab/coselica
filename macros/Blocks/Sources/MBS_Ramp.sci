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

function [x,y,typ]=MBS_Ramp(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,height,duration,offset,startTime,exprs]=...
              scicos_getvalue(['MBS_Ramp';__('Generate ramp signal')],...
                              [__('height [-] : Height of ramps');...
                               __('duration [s] : Duration of ramp');...
                               __('offset [-] : Offset of output signal');...
                               __('startTime [s] : Output = offset for time < startTime')],...
                              list('vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(height,duration,offset,startTime)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      height=1;
      duration=2;
      offset=0;
      startTime=0;
      model.sim='MBS_Ramp';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='MBS_Ramp';
      mo.inputs=[];
      mo.outputs=['y'];
      mo.parameters=list(['height','duration','offset','startTime'],...
                         list(height,duration,offset,startTime),...
                         [0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(height); sci2exp(duration); sci2exp(offset); sci2exp(startTime)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
    end
endfunction
