//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
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
     case 'plot' then
      standard_draw(arg1,%f,_CMTS_PositionSensor_dp);
     case 'getinputs' then
      [x,y,typ]=_CMTS_PositionSensor_ip(arg1);
     case 'getoutputs' then
      [x,y,typ]=_CMTS_PositionSensor_op(arg1);
     case 'getorigin' then
      [x,y]=standard_origin(arg1);
     case 'set' then
      x=arg1;
      graphics=x.graphics;
      exprs=graphics.exprs;
      model=x.model;
      while %t do

          [ok,value,exprs] = getvalue(['Generic Sensor'],..
                                      ['Please choose physical quantity (s - v - a)'],..
                                      list('str',1),exprs);
          if ~ok then
              break
          end
          if value <> ['s', 'v', 'a']
              ok = %f
              message("Physical quantity must be s,v or a")
          end
          if ok
              select value
               case 's'
                mo=modelica();
                mo.model='Coselica.Mechanics.Translational.Sensors.PositionSensor';
                mo.inputs=['flange'];
                mo.outputs=['s'];
                mo.parameters=list([],list(),[]);
                model.equations=mo;
                graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position<br><br>"]
               case 'v'
                mo=modelica();
                mo.model='Coselica.Mechanics.Translational.Sensors.SpeedSensor';
                mo.inputs=['flange'];
                mo.outputs=['v'];
                mo.parameters=list([],list(),[]);
                model.equations=mo;
                graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Speed<br><br>"]
               case 'a'
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
      exprs=['s'];
      x=standard_define([80, 60],model,exprs,list([], 0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[TransInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[RealOutputStyle()];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position"]
    end
endfunction