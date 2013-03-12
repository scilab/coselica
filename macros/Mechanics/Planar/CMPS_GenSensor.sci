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

function [x,y,typ]=CMPS_GenSensor(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=x.graphics;
      exprs=graphics.exprs;
      model=x.model;
      while %t do
          [ok,value,exprs] = getvalue([__('Generic Sensor')],..
                                      [__('Choose physical quantity : (0) position, (1) speed, (2) acceleration')],..
                                      list('vec',1),exprs);
          if ~ok then
              break
          end
          if value <> [0,1,2]
              ok = %f
              message(__('Physical quantity must be 0, 1 or 2'));
          end
          if ok
              mo=modelica();
              mo.inputs=['frame_a'];
              select value
               case 0
                mo.model='Coselica.Mechanics.Planar.Sensors.AbsPosition';
                mo.outputs=['y'];
                style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position"]
               case 1
                mo.model='Coselica.Mechanics.Planar.Sensors.AbsVelocity';
                mo.outputs=['y'];
                style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Speed"]
               case 2
                mo.model='Coselica.Mechanics.Planar.Sensors.AbsAcceleration';
                mo.outputs=['y'];
                style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Acceleration"]
              end
              mo.parameters=list([],list(),[]);
              model.equations=mo;
              graphics.exprs = exprs;
              graphics.style=style;
              x.model = model;
              x.graphics = graphics;
              break
          end
      end
     case 'define' then
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Sensors.AbsPosition';
      mo.inputs=['frame_a'];
      mo.outputs=['y'];
      mo.parameters=list([],list(),[]);
      model.equations=mo;
      exprs=['0'];
      x=standard_define([2, 2],model,exprs,list([], 0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[PlanInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position"]
    end
endfunction
