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

function [x,y,typ]=MEAI_IdealOpAmp(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,v1,v2,i1,i2,exprs]=...
              getvalue(['';'MEAI_IdealOpAmp';'';'Ideal operational amplifier (norator-nullator pair)';''],...
                       [' v1 [V] : Voltage drop over the left port';' v2 [V] : Voltage drop over the right port';' i1 [A] : Current flowing from pos. to neg. pin of the left port';' i2 [A] : Current flowing from pos. to neg. pin of the right port'],...
                       list('vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(v1,v2,i1,i2)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      v1=0; v2=5; i1=0; i2=1;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Ideal.IdealOpAmp';
      mo.inputs=['p1','p2'];
      mo.outputs=['n1','n2'];
      mo.parameters=list(['v1','v2','i1','i2'],...
                         list(v1,v2,i1,i2),...
                         [0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(v1);sci2exp(v2);sci2exp(i1);sci2exp(i2)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(), ElecInputStyle()];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle()];
    end
endfunction
