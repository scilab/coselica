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

function [x,y,typ]=MEMC_AirGapR(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,Lmd,Lmq,m,p,exprs]=...
              getvalue(['';'MEMC_AirGapR';'';'Airgap in rotor-fixed coordinate system';''],...
                       ['Lmd (H): main field inductance d-axis';'Lmq (H): main field inductance q-axis';' m : Number of phases';'p : Number of pole pairs (minimum 1)'],...
                       list('vec',1,'vec',1,'vec',1,'vec',1),exprs);
          mess=[];
          if ~ok then break, end
          if p < 1 then
              mess=[mess;_('Number of pole must be greater than 1')];
              ok=%f
          end
          if ok then
              model.equations.parameters(2)=list(Lmd,Lmq,m,p)
              graphics.exprs=exprs;
              x.graphics=graphics;x.model=model;
              break
          else
              message(mess);
          end
      end
     case 'define' then
      model=scicos_model();
      Lmd=1; Lmq=1; m=3; p=1;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Machines.Components.AirGapR';
      mo.inputs=['spacePhasor_s','support'];
      mo.outputs=['spacePhasor_r','flange'];
      mo.parameters=list(['Lmd','Lmq','m','p'],...
                         list(Lmd,Lmq,m,p),...
                         [0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(Lmd);sci2exp(Lmq);sci2exp(m);sci2exp(p)];

      x=standard_define([2 2],model,exprs,[]);
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(), RotInputStyle()];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[ElecOutputStyle(), RotOutputStyle()];
    end
endfunction
