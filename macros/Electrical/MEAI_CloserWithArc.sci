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

function [x,y,typ]=MEAI_CloserWithArc(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;
      exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,Ron,Goff,V0,dVdt,Vmax,exprs]=...
              getvalue(['MEAI_CloserWithArc';__('Ideal closing switch with simple arc model')],...
                       [__('Ron [Ohm] : Closed switch resistance');...
                        __('Goff [S] : Opened switch conductance');...
                        __('V0 [V] : Initial arc voltage');...
                        __('dV/dt [V/s] : Arc voltage slope');...
                        __('Vmax [V] : Max. arc voltage')],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(Ron,Goff,V0,dVdt,Vmax)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      Ron=0.00001; Goff=0.00001; V0=30; dVdt=10000.0; Vmax=60;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Ideal.CloserWithArc';
      mo.inputs=['p','control'];
      mo.outputs=['n'];
      mo.parameters=list(['Ron','Goff','V0','dVdt','Vmax'],...
                         list(Ron,Goff,V0,dVdt,Vmax),...
                         [0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(Ron);sci2exp(Goff);sci2exp(V0);sci2exp(dVdt);sci2exp(Vmax)];
      x=standard_define([2 2],model,exprs,[]);
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(),RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ElecOutputStyle()];
    end
endfunction
