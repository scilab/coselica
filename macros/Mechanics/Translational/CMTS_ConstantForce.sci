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

function [x,y,typ]=CMTS_ConstantForce(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,f_constant,exprs]=..
              getvalue(['CMTS_ConstantForce';__('Constant force, not dependent on speed')],..
                       [__('f_constant [N] : Nominal force (if negative, force is acting as load)')],..
                       list('vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(f_constant)
          model.in=[];
          model.out=[1;1];
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      f_constant=1;
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[];
      model.out=[1;1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Sources.ConstantForce';
      mo.inputs=[];
      mo.outputs=['flange','support'];
      mo.parameters=list(['f_constant'],..
                         list(f_constant),..
                         [0]);
      model.equations=mo;
      exprs=[strcat(sci2exp(f_constant))];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[TransOutputStyle(), TransOutputStyle()];
    end
endfunction
