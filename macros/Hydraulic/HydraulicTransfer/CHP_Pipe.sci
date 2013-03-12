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

function [x,y,typ]=CHP_Pipe(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
//    T=arg1.graphics.exprs(1);
//    standard_draw(arg1,%f,_MTH_FixedTemperature_dp);
  case 'getinputs' then
//    [x,y,typ]=_MTH_FixedTemperature_ip(arg1);
  case 'getoutputs' then
//    [x,y,typ]=_MTH_FixedTemperature_op(arg1);
  case 'getorigin' then
//    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,L,D,C,exprs]=...
        getvalue(['CHP_Pipe';__('Pipe with hydraulic resistor from the Hazen-William friction loss equation')],...
        [__('L [ft] : Pipe length');...
         __('D [in] : Pipe diameter');...
         __('C [-] : Hazen-William coefficient')],...
        list('vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(L,D,C)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    L=1000; D=12; C=130;
    model.rpar=[L,D,C];
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Coselica.Hydraulic.Piping.Pipe';
      mo.inputs=['Inlet'];
      mo.outputs=['Outlet'];
      mo.parameters=list(['Lval','Dval','Cval'],...
                         list(L,D,C),...
                         [0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=string([L;D;C]);

    x=standard_define([2 2],model,exprs,list([],0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[HydraulicInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[HydraulicOutputStyle()];
  end
endfunction
