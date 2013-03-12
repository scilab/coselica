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

function [x,y,typ]=CMTC_Lever(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,L1,L2,L,exprs]=..
              getvalue(['CMTC_Lever';__('Lever assuming small angle deviation (without mass and inertia; geometric constraint)')],..
                       [__('L1 [m] : Length of arm 1 (>0)');...
                        __('L2 [m] : Length of arm 2 (>0)');...
                        __('L [m] : Geometric constraint L=(L2*s1+L1*s2)/(L1+L2)-s')],..
                       list('vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(L1,L2,L)
          model.in=[1];
          model.out=[1;1];
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      L1=1;
      L2=1;
      L=0;
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1;1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Components.Lever';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b1','flange_b2'];
      mo.parameters=list(['L1','L2','L'],..
                         list(L1,L2,L),..
                         [0,0,0]);
      model.equations=mo;
      exprs=[strcat(sci2exp(L1));strcat(sci2exp(L2));strcat(sci2exp(L))];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[TransInputStyle()];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[TransOutputStyle(), TransOutputStyle()];
    end
endfunction
