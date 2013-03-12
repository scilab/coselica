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

function [x,y,typ]=CMPP_PointMass(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,m,exprs]=..
              getvalue(['CMPP_PointMass';__('Rigid body where body rotation and inertia is neglected (no states)')],..
                       [__('m [kg] : Mass of mass point (m > 0)')],..
                       list('vec',1),exprs);
          if ~ok then break, end
          model.in=[1];
          model.out=[];
          model.equations.parameters(2)=list(m)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      m=1;
      exprs=[strcat(sci2exp(m))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[];
      mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Parts.PointMass';
      mo.inputs=['frame_a'];
      mo.outputs=[];
      mo.parameters=list(['m'],..
                         list(m),..
                         [0]);
      model.equations=mo;
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[PlanInputStyle()];
      x.graphics.out_implicit=[];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=bottom;spacing=0;displayedLabel=<br><br>m = %s Kg"]
    end
endfunction
