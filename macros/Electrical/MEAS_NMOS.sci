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

function [x,y,typ]=MEAS_NMOS(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,W,L,Beta,Vt,K2,K5,dW,dL,RDS,exprs]=...
              getvalue(['';'MEAS_NMOS';'';'Simple MOS Transistor';''],...
                       [' W [m] : Width';' L [m] : Length';' Beta [A/(V*V)] : Transconductance parameter';' Vt [V] : Zero bias threshold voltage';' K2 [-] : Bulk threshold parameter';' K5 [-] : Reduction of pinch-off region';' dW [m] : narrowing of channel';' dL [m] : shortening of channel';' RDS [Ohm] : Drain-Source-Resistance'],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(W,L,Beta,Vt,K2,K5,dW,dL,RDS)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      W=0.00002;
      L=0.000006;
      Beta=0.000041;
      Vt=0.8;
      K2=1.144;
      K5=0.7311;
      dW=-0.0000025;
      dL=-0.0000015;
      RDS=10000000;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Semiconductors.NMOS';
      mo.inputs=['G'];
      mo.outputs=['D','B','S'];
      mo.parameters=list(['W','L','Beta','Vt','K2','K5','dW','dL','RDS'],...
                         list(W,L,Beta,Vt,K2,K5,dW,dL,RDS),...
                         [0,0,0,0,0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(W);sci2exp(L);sci2exp(Beta);sci2exp(Vt);sci2exp(K2);sci2exp(K5);sci2exp(dW);sci2exp(dL);sci2exp(RDS)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[ElecInputStyle()];
      x.graphics.out_implicit=['I','I','I'];
      x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle(), ElecOutputStyle()];
    end
endfunction
