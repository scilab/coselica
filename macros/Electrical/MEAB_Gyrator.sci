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

function [x,y,typ]=MEAB_Gyrator(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    G1=arg1.graphics.exprs(1);
    G2=arg1.graphics.exprs(2);
    standard_draw(arg1,%f,_MEAI_TwoPort_dp);
  case 'getinputs' then
    [x,y,typ]=_MEAI_TwoPort_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MEAI_TwoPort_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,G1,G2,exprs]=...
        getvalue(['';'MEAB_Gyrator';'';'Gyrator';''],...
        [' G1 [S] : Gyration conductance';' G2 [S] : Gyration conductance'],...
        list('vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(G1,G2)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    G1=1;
    G2=1;
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Modelica.Electrical.Analog.Basic.Gyrator';
      mo.inputs=['p1','n1'];
      mo.outputs=['p2','n2'];
      mo.parameters=list(['G1','G2'],...
                         list(G1,G2),...
                         [0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(G1);sci2exp(G2)];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I','I'];
    x.graphics.in_style=[ElecInputStyle(), ElecInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle()];
  end
endfunction
