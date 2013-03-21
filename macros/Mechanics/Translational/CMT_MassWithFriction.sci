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

function [x,y,typ]=CMT_MassWithFriction(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,m,F_prop,F_Coulomb,F_Stribeck,fexp,mode_start,L,exprs]=..
              getvalue(['CMT_MassWithFriction';__('Sliding mass with Stribeck friction')],..
                       [__('m [kg] : Mass of the sliding mass');...
                        __('F_prop [N/(m/s)] : Velocity dependent friction'); ...
                        __('F_Coulomb [N] : Constant friction: Coulomb force');...
                        __('F_Stribeck [N] : Stribeck effect'); ...
                        __('fexp [1/(m/s)] : Exponential decay of Stribeck effect');...
                        __('mode_start [-] : Initial sliding mode (-1=Backward, 0=Sticking, 1=Forward)'); ...
                        __('L [m] : Length of component from left flange to right flange (= flange_b.s - flange_a.s)')],..
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(m,F_prop,F_Coulomb,F_Stribeck,fexp,mode_start,L)
          model.in=[1];
          model.out=[1];
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      m=1;
      F_prop=1;
      F_Coulomb=5;
      F_Stribeck=10;
      fexp=2;
      mode_start=0;
      L=0;
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Translational.MassWithFriction';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b'];
      mo.parameters=list(['m','F_prop','F_Coulomb','F_Stribeck','fexp','mode_start','L'],..
                         list(m,F_prop,F_Coulomb,F_Stribeck,fexp,mode_start,L),..
                         [0,0,0,0,0,0,0]);
      model.equations=mo;
      exprs=[strcat(sci2exp(m));strcat(sci2exp(F_prop));strcat(sci2exp(F_Coulomb));strcat(sci2exp(F_Stribeck));strcat(sci2exp(fexp));strcat(sci2exp(mode_start));strcat(sci2exp(L))];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[TransInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[TransOutputStyle()];
    end
endfunction
