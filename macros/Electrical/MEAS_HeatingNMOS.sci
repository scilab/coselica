//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012-2012 - Scilab Enterprises - Bruno JOFRET
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//

function [x,y,typ]=MEAS_HeatingNMOS(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,W,L,Beta,Vt,K2,K5,dW,dL,RDS,Tnom,kvt,kk2,exprs]=...
              getvalue(['MEAS_HeatingNMOS';__('Simple MOS Transistor with heating port')],...
                       [__('W [m] : Width');...
                        __('L [m] : Length');...
                        __('Beta [A/(V*V)] : Transconductance parameter');...
                        __('Vt [V] : Zero bias threshold voltage');...
                        __('K2 [-] : Bulk threshold parameter');...
                        __('K5 [-] : Reduction of pinch-off region');...
                        __('dW [m] : narrowing of channel');...
                        __('dL [m] : shortening of channel');...
                        __('RDS [Ohm] : Drain-Source-Resistance');...
                        __('Tnom (K) : Parameter measurement temperature');...
                        __('kvt : fitting parameter for Vt');...
                        __('kk2 : fitting parameter for K22')],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(W,L,Beta,Vt,K2,K5,dW,dL,RDS,Tnom,kvt,kk2)
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
      Tnom = 300.15 ;
      kvt= -0.00696;
      kk2 = 0.0006;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Semiconductors.HeatingNMOS';
      mo.inputs=['G','heatPort'];
      mo.outputs=['D','B','S'];
      mo.parameters=list(['W','L','Beta','Vt','K2','K5','dW','dL','RDS','Tnom','kvt','kk2'],...
                         list(W,L,Beta,Vt,K2,K5,dW,dL,RDS,Tnom,kvt,kk2),...
                         [0,0,0,0,0,0,0,0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(W);sci2exp(L);sci2exp(Beta);sci2exp(Vt);sci2exp(K2);sci2exp(K5);sci2exp(dW);sci2exp(dL);sci2exp(RDS);sci2exp(Tnom);sci2exp(kvt);sci2exp(kk2)];
      x=standard_define([2 2],model,exprs,[]);
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(),ThermalInputStyle()];
      x.graphics.out_implicit=['I','I','I'];
      x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle(), ElecOutputStyle()];
    end
endfunction
