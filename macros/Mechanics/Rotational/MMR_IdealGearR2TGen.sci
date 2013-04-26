// Coselica Toolbox for Xcos
// Copyright (C) 2013 - Scilab Enterprises - Bruno JOFRET
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

function [x,y,typ]=MMR_IdealGearR2TGen(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;
      exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok, ratio, fixedframe, exprs]=...
              getvalue(__('Gearbox transforming rotational into translational motion'),...
                       [__('ratio [rad/m] : transmission ratio (flange_a.phi/flange_b.s)');
                        __('Fixed frame (1 : Yes / 0 : No)')],...
                       list('vec', 1, 'vec', 1),exprs);

          if ~ok then
              break
          end

          if fixedframe<>1 & fixedframe<>0 then
              message(__('Choose 1 or 0 in order to specify fixed frame or not'));
              ok = %f
          end


          model.equations.parameters(2)=list(ratio)

          if ok then
              if fixedframe==1 then
                  model.equations.model = 'Modelica.Mechanics.Rotational.IdealGearR2T0';
                  model.in = [1];
                  model.out = [1];
                  model.equations.inputs=['flange_a'];
                  model.equations.outputs = ['flange_b'];
                  graphics.in_implicit=['I'];
                  graphics.out_implicit=['I'];
                  graphics.in_style=[RotInputStyle()];
                  graphics.out_style=[TransInputStyle()];
                  graphics.style = "MMR_IdealGearR2T0";
              else
                  model.equations.model = 'Modelica.Mechanics.Rotational.IdealGearR2T';
                  model.equations.inputs=['flange_a','bearingR'];
                  model.equations.outputs=['flange_b','bearingT'];
                  model.in = [1 ; 1]
                  model.out = [1 ; 1]
                  graphics.in_implicit=['I','I'];
                  graphics.out_implicit=['I','I'];
                  graphics.in_style=[RotInputStyle(), RotOutputStyle()];
                  graphics.out_style=[TransInputStyle(), TransOutputStyle()];
                  graphics.style = "MMR_IdealGearR2T";
              end
              graphics.exprs=exprs;
              x.graphics=graphics;
              x.model=model;
              break
          end
      end
     case 'define' then
      model=scicos_model();
      ratio=1;
      model.sim='Modelica.Mechanics.Rotational.IdealGearR2T0';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Mechanics.Rotational.IdealGearR2T0';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b'];
      mo.parameters=list(['ratio'],...
                         list(ratio),...
                         [0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(ratio); "1"]; // Fixed frame
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RotInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[TransInputStyle()];
      x.graphics.style = "MMR_IdealGearR2T0";
    end
endfunction
