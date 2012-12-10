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

function [x,y,typ]=MEAB_OpAmp(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,Slope,exprs]=...
              getvalue(['';'MEAB_OpAmp';'';'Simple nonideal model of an OpAmp with limitation';''],...
                       [' Slope [-] : Slope of the out.v/vin characteristic at vin=0'],...
                       list('vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(Slope)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      Slope=1;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Basic.OpAmp';
      mo.inputs=['in_n','in_p','VMax'];
      mo.outputs=['out','VMin'];
      mo.parameters=list(['Slope'],...
                         list(Slope),...
                         [0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(Slope)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I','I','I'];
      x.graphics.in_style=[ElecInputStyle(), ElecInputStyle(), ElecInputStyle()];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle()];
    end
endfunction
