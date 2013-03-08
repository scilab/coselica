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

function [x,y,typ]=MEMC_PartialAirGapDC(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,turnsRatio,exprs]=...
              getvalue(['MEMC_PartialAirGapDC';__('Partial airgap model of a DC machine')],...
                       [__('turnsRatio : ratio of armature turns over number of turns of the excitation winding')],...
                       list('vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(turnsRatio)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      turnsRatio=1;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Machines.Components.PartialAirGapDC';
      mo.inputs=['pin_ap','pin_ep','support'];
      mo.outputs=['pin_an','pin_en','flange'];
      mo.parameters=list(['turnsRatio'],...
                         list(turnsRatio),...
                         [0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(turnsRatio)];

      x=standard_define([2 2],model,exprs,[]);
      x.graphics.in_implicit=['I','I','I'];
      x.graphics.in_style=[ElecInputStyle(), ElecInputStyle(),RotInputStyle()];
      x.graphics.out_implicit=['I','I','I'];
      x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle(),RotOutputStyle()];
    end
endfunction
