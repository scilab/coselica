//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
// Copyright (C) 2011-2011 - DIGITEO - Bruno JOFRET
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//

function [x,y,typ]=CMTS_GenSensor(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=x.graphics;
      exprs=graphics.exprs;
      model=x.model;
      while %t do

          [ok,value,exprs] = getvalue(['Generic Sensor'],..
                                      ['Please choose physical quantity : (0) position, (1) speed, (2) acceleration'],..
                                      list('vec',1),exprs);
          if ~ok then
              break
          end
          if value <> [0,1,2]
              ok = %f
              message(_("Physical quantity must be 0, 1 or 2"))
          end
          if ok
              select value
               case 0
                mo=modelica();
                mo.model='Coselica.Mechanics.Translational.Sensors.PositionSensor';
                mo.inputs=['flange'];
                mo.outputs=['s'];
                mo.parameters=list([],list(),[]);
                model.equations=mo;
                graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position<br><br>"]
               case 1
                mo=modelica();
                mo.model='Coselica.Mechanics.Translational.Sensors.SpeedSensor';
                mo.inputs=['flange'];
                mo.outputs=['v'];
                mo.parameters=list([],list(),[]);
                model.equations=mo;
                graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Speed<br><br>"]
               case 2
                mo=modelica();
                mo.model='Coselica.Mechanics.Translational.Sensors.AccSensor';
                mo.inputs=['flange'];
                mo.outputs=['a'];
                mo.parameters=list([],list(),[]);
                model.equations=mo;
                graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Acceleration<br><br>"]
              end
              graphics.exprs = exprs;
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
      mo.model='Coselica.Mechanics.Translational.Sensors.PositionSensor';
      mo.inputs=['flange'];
      mo.outputs=['s'];
      mo.parameters=list([],list(),[]);
      model.equations=mo;
      exprs=['0'];
      x=standard_define([2, 2],model,exprs,list([], 0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[TransInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position"]
    end
endfunction