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

function [x,y,typ]=CBN_Hysteresis(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,uOn,uOff,yOn,yOff,y_start,exprs]=...
              getvalue(['CBN_Hysteresis';__('Switch output between two constants with hysteresis')],...
                       [__('uOn [-] : Switch on when u >= uOn');...
                        __('uOff [-] : Switch off when u <= uOff');...
                        __('yOn [-] : Output when switched on');...
                        __('yOff [-] : Output when switched off');...
                        __('y_start [-] : Start value of output')],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(uOn,uOff,yOn,yOff,y_start)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      uOn=1;
      uOff=0;
      yOn=1;
      yOff=0;
      y_start=0;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Coselica.Blocks.Nonlinear.Hysteresis';
      mo.inputs=['u'];
      mo.outputs=['y'];
      mo.parameters=list(['uOn','uOff','yOn','yOff','y_start'],...
                         list(uOn,uOff,yOn,yOff,y_start),...
                         [0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(uOn);sci2exp(uOff);sci2exp(yOn);sci2exp(yOff);sci2exp(y_start)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
    end
endfunction
