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

function [x,y,typ]=CMRC_Disc(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,deltaPhi,exprs]=...
              getvalue(['CMRC_Disc';__('1-dim. rotational rigid component without inertia, where right flange is rotated by a fixed angle with respect to left flange')],...
                       [__('deltaPhi [rad] : Fixed rotation of left flange with respect to right flange (= flange_b.phi - flange_a.phi)')],...
                       list('vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(deltaPhi)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      deltaPhi=0;
      model.sim='CMRC_Disc';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='CMRC_Disc';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b'];
      mo.parameters=list(['deltaPhi'],...
                         list(deltaPhi),...
                         [0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(deltaPhi)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RotInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RotOutputStyle()];
    end
endfunction
