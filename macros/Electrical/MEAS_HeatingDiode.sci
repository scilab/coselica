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

function [x,y,typ]=MEAS_HeatingDiode(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,Ids,Maxexp,R,EG,N,TNOM,XTI,exprs]=...
              getvalue(['MEAS_HeatingDiode';__('Simple diode with heating port')],...
                       [__('Ids [A] : Saturation current');...
                        __('Maxexp [-] : Max. exponent for linear continuation');...
                        __('R [Ohm] : Parallel ohmic resistance');...
                        __('EG : activation energy');...
                        __('N : Emission coefficient');...
                        __('TNOM (K) : Parameter measurement temperature');...
                        __('XTI : Temperature exponent of saturation current')],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(Ids,Maxexp,R,EG,N,TNOM,XTI)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      Ids=0.000001;
      Maxexp=15;
      R=1.000D+08;
      EG = 1.11;
      N = 1;
      TNOM = 300.15;
      XTI = 3 ;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Semiconductors.HeatingDiode';
      mo.inputs=['p','n'];
      mo.outputs=['heatPort'];
      mo.parameters=list(['Ids','Maxexp','R','EG','N','TNOM','XTI'],...
                         list(Ids,Maxexp,R,EG,N,TNOM,XTI),...
                         [0,0,0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(Ids);sci2exp(Maxexp);sci2exp(R);sci2exp(EG);sci2exp(N);sci2exp(TNOM);sci2exp(XTI);];

      x=standard_define([2 2],model,exprs,[]);
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(),ElecOutputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ThermalOutputStyle()];
    end
endfunction
