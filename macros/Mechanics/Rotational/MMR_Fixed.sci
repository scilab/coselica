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

function [x,y,typ]=MMR_Fixed(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    phi0=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_MMR_Fixed_dp);
  case 'getinputs' then
    [x,y,typ]=_MMR_Fixed_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MMR_Fixed_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,phi0,exprs]=...
        getvalue(['';'MMR_Fixed';'';'Flange fixed in housing at a given angle';''],...
        [' phi0 [rad] : Fixed offset angle of housing'],...
        list('vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(phi0)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    phi0=0;
    model.sim='MMR_Fixed';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MMR_Fixed';
      mo.inputs=[];
      mo.outputs=['flange_b'];
      mo.parameters=list(['phi0'],...
                         list(phi0),...
                         [0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(phi0)];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=[];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RotOutputStyle()];
  end
endfunction
