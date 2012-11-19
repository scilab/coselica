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

function [x,y,typ]=MBM_Gain(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;
      exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,k,exprs]=..
              getvalue(['';'MBM_Gain';'';'Output the product of a gain value with the input signal';''],..
                       [' k [-] : Gain value multiplied with input signal'],..
                       list('vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(k)
          model.in=[1];
          model.out=[1];
          graphics.exprs=exprs;
          x.graphics=graphics;
          x.model=model;
          break
      end
     case 'define' then
      k=1;
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Modelica.Blocks.Math.Gain';
      mo.inputs=['u'];
      mo.outputs=['y'];
      mo.parameters=list(['k'],..
                         list(k),..
                         [0]);
      model.equations=mo;
      exprs=[strcat(sci2exp(k))];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=middle;displayedLabel=%s"]
    end
endfunction
