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

function [x,y,typ]=MEMC_DamperCage(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,Lrsigmad,Lrsigmaq,Rrd,Rrq,exprs]=...
              getvalue(['MEMC_DamperCage';__('Damper Cage')],...
                       [__('Lrsigmad (H): tray inductance in d-axis per phase translated to stator');...
                        __('Lrsigmaq (H): tray inductance in q-axis per phase translated to stator');...
                        __('Rrd (Ohm): warm resistance in d-axis per phase translated to stator');...
                        __('Rrq (Ohm): warm resistance in q-axis per phase translated to stator')],...
                       list('vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(Lrsigmad,Lrsigmaq,Rrd,Rrq)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      Lrsigmad=1;Lrsigmaq=1;Rrd=1;Rrq=1;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Machines.Components.DamperCage';
      mo.inputs=[];
      mo.outputs=['spacePhasor_r'];
      mo.parameters=list(['Lrsigmad','Lrsigmaq','Rrd','Rrq'],...
                         list(Lrsigmad,Lrsigmaq,Rrd,Rrq),...
                         [0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(Lrsigmad);sci2exp(Lrsigmaq);sci2exp(Rrd);sci2exp(Rrq)];

      x=standard_define([2 2],model,exprs,[]);
      x.graphics.in_implicit=[];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ElecOutputStyle()];
    end
endfunction
