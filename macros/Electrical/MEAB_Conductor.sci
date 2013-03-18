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

function [x,y,typ]=MEAB_Conductor(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,G,exprs]=...
              getvalue(['MEAB_Conductor';__('Ideal linear electrical conductance')],...
                       [__('G [Ohm^-1] : Conductance')],...
                       list('vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(G)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      G=1;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Basic.Conductor';
      mo.inputs=['p'];
      mo.outputs=['n'];
      mo.parameters=list(['G'],...
                         list(G),...
                         [0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(G)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[ElecInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ElecOutputStyle()];
    end
endfunction
