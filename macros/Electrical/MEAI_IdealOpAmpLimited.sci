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

function [x,y,typ]=MEAI_IdealOpAmpLimited(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
     case 'define' then
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Analog.Ideal.IdealOpAmpLimited';
      mo.inputs=['in_n','in_p','VMax'];
      mo.outputs=['out','VMin'];
      mo.parameters=list([],...
                         list(),...
                         []);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I','I','I'];
      x.graphics.in_style=[ElecInputStyle(), ElecInputStyle(), ElecInputStyle()];
      x.graphics.out_implicit=['I','I'];
      x.graphics.out_style=[ElecOutputStyle(), ElecOutputStyle()];
    end
endfunction
