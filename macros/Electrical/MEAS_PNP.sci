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

function [x,y,typ]=MEAS_PNP(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    Bf=arg1.graphics.exprs(1);
    Br=arg1.graphics.exprs(2);
    Is=arg1.graphics.exprs(3);
    Vak=arg1.graphics.exprs(4);
    Tauf=arg1.graphics.exprs(5);
    Taur=arg1.graphics.exprs(6);
    Ccs=arg1.graphics.exprs(7);
    Cje=arg1.graphics.exprs(8);
    Cjc=arg1.graphics.exprs(9);
    Phie=arg1.graphics.exprs(10);
    Me=arg1.graphics.exprs(11);
    Phic=arg1.graphics.exprs(12);
    Mc=arg1.graphics.exprs(13);
    Gbc=arg1.graphics.exprs(14);
    Gbe=arg1.graphics.exprs(15);
    Vt=arg1.graphics.exprs(16);
    EMin=arg1.graphics.exprs(17);
    EMax=arg1.graphics.exprs(18);
    standard_draw(arg1,%f,_MEAS_NPN_dp);
  case 'getinputs' then
    [x,y,typ]=_MEAS_NPN_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MEAS_NPN_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,Bf,Br,Is,Vak,Tauf,Taur,Ccs,Cje,Cjc,Phie,Me,Phic,Mc,Gbc,Gbe,Vt,EMin,EMax,exprs]=...
        getvalue(['';'MEAS_PNP';'';'Simple BJT according to Ebers-Moll';''],...
        [' Bf [-] : Forward beta';' Br [-] : Reverse beta';' Is [A] : Transport saturation current';' Vak [1/V] : Early voltage (inverse), 1/Volt';' Tauf [s] : Ideal forward transit time';' Taur [s] : Ideal reverse transit time';' Ccs [F] : Collector-substrat(ground) cap.';' Cje [F] : Base-emitter zero bias depletion cap.';' Cjc [F] : Base-coll. zero bias depletion cap.';' Phie [V] : Base-emitter diffusion voltage';' Me [-] : Base-emitter gradation exponent';' Phic [V] : Base-collector diffusion voltage';' Mc [-] : Base-collector gradation exponent';' Gbc [S] : Base-collector conductance';' Gbe [S] : Base-emitter conductance';' Vt [V] : Voltage equivalent of temperature';' EMin [-] : if x < EMin, the exp(x) function is linearized';' EMax [-] : if x > EMax, the exp(x) function is linearized'],...
        list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(Bf,Br,Is,Vak,Tauf,Taur,Ccs,Cje,Cjc,Phie,Me,Phic,Mc,Gbc,Gbe,Vt,EMin,EMax)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    Bf=50;
    Br=0.1;
    Is=1.000D-16;
    Vak=0.02;
    Tauf=1.200D-10;
    Taur=5.000D-09;
    Ccs=1.000D-12;
    Cje=4.000D-13;
    Cjc=5.000D-13;
    Phie=0.8;
    Me=0.4;
    Phic=0.8;
    Mc=0.333;
    Gbc=1.000D-15;
    Gbe=1.000D-15;
    Vt=0.02585;
    EMin=-100;
    EMax=40;
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='Modelica.Electrical.Analog.Semiconductors.PNP';
      mo.inputs=['B'];
      mo.outputs=['C','E'];
      mo.parameters=list(['Bf','Br','Is','Vak','Tauf','Taur','Ccs','Cje','Cjc','Phie','Me','Phic','Mc','Gbc','Gbe','Vt','EMin','EMax'],...
                         list(Bf,Br,Is,Vak,Tauf,Taur,Ccs,Cje,Cjc,Phie,Me,Phic,Mc,Gbc,Gbe,Vt,EMin,EMax),...
                         [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(Bf);sci2exp(Br);sci2exp(Is);sci2exp(Vak);sci2exp(Tauf);sci2exp(Taur);sci2exp(Ccs);sci2exp(Cje);sci2exp(Cjc);sci2exp(Phie);sci2exp(Me);sci2exp(Phic);sci2exp(Mc);sci2exp(Gbc);sci2exp(Gbe);sci2exp(Vt);sci2exp(EMin);sci2exp(EMax)];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[ElecInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle()];
  end
endfunction
