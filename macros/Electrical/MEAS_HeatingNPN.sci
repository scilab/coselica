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

function [x,y,typ]=MEAS_HeatingNPN(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,Bf,Br,Is,Vak,Tauf,Taur,Ccs,Cje,Cjc,Phie,Me,Phic,Mc,Gbc,Gbe,EMin,EMax,Tnom,XTI,XTB,EG,NF,NR,exprs]=...
              getvalue(['MEAS_HeatingNPN';__('Simple BJT according to Ebers-Moll with heating port')],...
                       [__('Bf [-] : Forward beta');...
                        __('Br [-] : Reverse beta');...
                        __('Is [A] : Transport saturation current');...
                        __('Vak [1/V] : Early voltage (inverse), 1/Volt');...
                        __('Tauf [s] : Ideal forward transit time');...
                        __('Taur [s] : Ideal reverse transit time');...
                        __('Ccs [F] : Collector-substrat(ground) cap.');...
                        __('Cje [F] : Base-emitter zero bias depletion cap.');...
                        __('Cjc [F] : Base-coll. zero bias depletion cap.');...
                        __('Phie [V] : Base-emitter diffusion voltage');...
                        __('Me [-] : Base-emitter gradation exponent');...
                        __('Phic [V] : Base-collector diffusion voltage');...
                        __('Mc [-] : Base-collector gradation exponent');...
                        __('Gbc [S] : Base-collector conductance');...
                        __('Gbe [S] : Base-emitter conductance');...
                        __('EMin [-] : if x < EMin, the exp(x) function is linearized');...
                        __('EMax [-] : if x > EMax, the exp(x) function is linearized');...
                        __('Tnom (K): Parameter measurement temperature');...
                        __('XTI : Temperature exponent for effect on Is');...
                        __('XTB : Forward and reverse beta temperature exponent');...
                        __('EG : Energy gap for temperature effect on Is');...
                        __('NF : Forward current emission coefficient');...
                        __('NR : Reverse current emission coefficient')],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(Bf,Br,Is,Vak,Tauf,Taur,Ccs,Cje,Cjc,Phie,Me,Phic,Mc,Gbc,Gbe,EMin,EMax,Tnom,XTI,XTB,EG,NF,NR)
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
      Tnom = 300.15 ;
      XTI = 3 ;
      XTB = 0 ;
      EG = 1.11 ;
      NF = 1.0;
      NR = 1.0 ;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Semiconductors.HeatingNPN';
      mo.inputs=['B','heatPort'];
      mo.outputs=['C','E'];
      mo.parameters=list(['Bf','Br','Is','Vak','Tauf','Taur','Ccs','Cje','Cjc','Phie','Me','Phic','Mc','Gbc','Gbe','EMin','EMax','Tnom','XTI','XTB','EG','NF','NR'],...
                         list(Bf,Br,Is,Vak,Tauf,Taur,Ccs,Cje,Cjc,Phie,Me,Phic,Mc,Gbc,Gbe,EMin,EMax,Tnom,XTI,XTB,EG,NF,NR),...
                         [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(Bf);sci2exp(Br);sci2exp(Is);sci2exp(Vak);sci2exp(Tauf);sci2exp(Taur);sci2exp(Ccs);sci2exp(Cje);sci2exp(Cjc);sci2exp(Phie);sci2exp(Me);sci2exp(Phic);sci2exp(Mc);sci2exp(Gbc);sci2exp(Gbe);sci2exp(EMin);sci2exp(EMax);sci2exp(Tnom);sci2exp(XTI);sci2exp(XTB);sci2exp(EG);sci2exp(NF);sci2exp(NR)];

      x=standard_define([2 2],model,exprs,[]);
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(),ThermalInputStyle()];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle()];
    end
endfunction
