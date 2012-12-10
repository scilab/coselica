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

function [x,y,typ]=CMP_World(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,g,n,exprs]=..
              getvalue(['';'CMP_World';'';'World coordinate system with uniform gravity field';''],..
                       [' g [m/s2] : Constant gravity acceleration';' n [-] : Direction of gravity resolved in world frame (gravity = g*n/length(n))'],..
                       list('vec',1,'vec',2),exprs);
          if ~ok then break, end
          model.in=[];
          model.out=[1];
          model.equations.parameters(2)=list(g,n)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      g=9.81;
      n=[0,-1];
      exprs=[strcat(sci2exp(g));strcat(sci2exp(n))];
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[];
      model.out=[1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Planar.World';
      mo.inputs=[];
      mo.outputs=['frame_b'];
      mo.parameters=list(['g','n'],..
                         list(g,n),..
                         [0,0]);
      model.equations=mo;
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[PlanOutputStyle()];
    end
endfunction
