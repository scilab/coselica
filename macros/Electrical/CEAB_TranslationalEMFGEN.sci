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

function [x,y,typ]=CEAB_TranslationalEMFGEN(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;
      exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,k,fixedframe,exprs]=...
              getvalue(['';'CEAB_TranslationalEMEMFGEN';'';'Electromotoric force (electric/mechanic transformer)';''],...
                       [' k [N/A] : Transformation coefficient' ; ' Fixed frame (1 : Yes / 0 : No)'],...
                       list('vec',1,'vec',1),exprs);

          if ~ok then break, end

          //test error syntax
          if fixedframe<>1 & fixedframe<>0 then
              message(_('Choose 1 or 0 in order to specify fixed frame or not'));
              ok = %f
          end

          //no error
          if ok then
              if fixedframe==1 then //fixed frame -> emf0
                  mo=modelica();
                  mo.model='Coselica.Electrical.Analog.Basic.TranslationalEMF0';
                  mo.inputs=['p','n'];
                  mo.outputs=['flange'];
                  mo.parameters=list(['k'],...
                                     list(k),...
                                     [0]);
                  model.equations=mo;
                  model.in=ones(size(mo.inputs,'*'),1);
                  model.out=ones(size(mo.outputs,'*'),1);
                  x=standard_define([2 2],model,exprs,list([],0));
                  x.graphics.in_implicit=['I','I'];
                  x.graphics.in_style=[ElecInputStyle(),ElecOutputStyle()];
                  x.graphics.out_implicit=['I'];
                  x.graphics.out_style=[TransOutputStyle()];
              else
                  mo=modelica();
                  mo.model='Coselica.Electrical.Analog.Basic.TranslationalEMF';
                  mo.inputs=['p','n'];
                  mo.outputs=['flange','support'];
                  mo.parameters=list(['k'],...
                                     list(k),...
                                     [0]);
                  model.equations=mo;
                  model.in=ones(size(mo.inputs,'*'),1);
                  model.out=ones(size(mo.outputs,'*'),1);
                  x=standard_define([2 2],model,exprs,list([],0));
                  x.graphics.in_implicit=['I','I'];
                  x.graphics.in_style=[ElecInputStyle(),ElecOutputStyle() ];
                  x.graphics.out_implicit=['I','I'];
                  x.graphics.out_style=[TransOutputStyle(), TransInputStyle()];
              end
          end


          break
      end
     case 'define' then
      model=scicos_model();
      k=1;
      fixed=1;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Coselica.Electrical.Analog.Basic.TranslationalEMF0';
      mo.inputs=['p','n'];
      mo.outputs=['flange'];
      mo.parameters=list(['k'],...
                         list(k),...
                         [0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(k);sci2exp(fixed)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(),ElecOutputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[TransOutputStyle()];
    end
endfunction
