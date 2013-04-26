//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012-2013 - Scilab Enterprises - Bruno JOFRET
// Copyright (C) 2012-2013 - David Violeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//

function [x,y,typ]=CCP_PWM(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,nb_bits,frequency,start_time,exprs]=...
              getvalue(['CCP_PWM';__('PWM')],...
                       [__('number of bits for duty cycle');...
                        __('frequency of signal (Hz)');...
                        __("start_time (s)")],...
                       list('vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(nb_bits,frequency,start_time)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      frequency=500;
      nb_bits=8;
      start_time=0;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Modelica.Electrical.Machines.Components.PWM';
      mo.inputs=['u'];
      mo.outputs=['y'];
      mo.parameters=list(['nb_bits','frequency','startTime'],...
                         list(nb_bits,frequency,start_time),...
                         [0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(nb_bits);sci2exp(frequency);sci2exp(start_time)];

      x=standard_define([2 2],model,exprs,list([],0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
    end
endfunction
