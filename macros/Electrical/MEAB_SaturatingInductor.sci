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

function [x,y,typ]=MEAB_SaturatingInductor(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,Lnom,Inom,Lzer,Linf,exprs]=...
              getvalue(['';'MEAB_SaturatingInductor';'';'Simple model of an inductor with saturation';''],...
                       [' Lnom [H] : Nominal inductance at nominal current';' Inom [A] : Nominal current'; ' Lzer [H] : Inductance near current 0 (>Lnom)';' Linf [H] : Inductance at large currents (< Lnom)'],...
                       list('vec',1,'vec',1,'vec',1,'vec',1),exprs);
          mess=[];
          if ~ok then break, end
          if Lzer <=Lnom then
              mess=[mess;_('Lzer has to be greater than Lnom')];
              ok=%f
          end
          if Linf >=Lnom then
              mess=[mess;_('Linf has to be less than Lnom')];
              ok=%f
          end
          if ok then
              model.equations.parameters(2)=list(Lnom,Inom,Lzer,Linf)
              graphics.exprs=exprs;
              x.graphics=graphics;x.model=model;
              break
          else
              message(mess);
          end

      end
     case 'define' then
      model=scicos_model();
      Inom=1, Lnom=1, Lzer=2*Lnom, Linf=Lnom/2;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Basic.SaturatingInductor';
      mo.inputs=['p'];
      mo.outputs=['n'];
      mo.parameters=list(['Lnom','Inom','Lzer','Linf'],...
                         list(Lnom,Inom,Lzer,Linf),...
                         [0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(Lnom);sci2exp(Inom);sci2exp(Lzer);sci2exp(Linf)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[ElecInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ElecOutputStyle()];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=bottom;verticalAlign=bottom;displayedLabel=Lnom=%s"]
    end
endfunction
