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

function [x,y,typ]=CMRS_GenRelSensor(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'plot' then
//      standard_draw(arg1,%f,_CMTS_PositionSensor_dp);
     case 'getinputs' then
//      [x,y,typ]=_CMTS_PositionSensor_ip(arg1);
     case 'getoutputs' then
//      [x,y,typ]=_CMTS_PositionSensor_op(arg1);
     case 'getorigin' then
//      [x,y]=standard_origin(arg1);
     case 'set' then
      x=arg1;
      graphics=x.graphics;
      exprs=graphics.exprs;
      model=x.model;
      while %t do

          [ok,value,exprs] = getvalue(['Generic Relative Sensor'],..
                                      ['Choose physical quantity : (0) position, (1) speed, (2) acceleration'],..
                                      list('vec',1),exprs);
          if ~ok then
              break
          end
          if value <> [0,1,2]
              ok = %f
              message("Physical quantity must be 0, 1 or 2")
          end
          if ok
              mo=modelica();
              mo.inputs=['flange_a'];
              select value
               case 0
                mo.model='MMRS_RelAngleSensor';
                mo.outputs=['flange_b','phi_rel'];
                style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=-3;displayedLabel=Position<br><br>"]
               case 1
                mo.model='MMRS_RelSpeedSensor';
                mo.outputs=['flange_b','w_rel'];
                style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=-3;displayedLabel=Speed<br><br>"]
               case 2
                mo.model='MMRS_RelAccSensor';
                mo.outputs=['flange_b','a_rel'];
                style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=-3;displayedLabel=Acceleration<br><br>"]
              end
              mo.parameters=list([],list(),[]);
              model.equations=mo;
              model.in=ones(size(mo.inputs,'*'),1);
              model.out=ones(size(mo.outputs,'*'),1);
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
      mo=modelica();
      mo.model='MMRS_RelAngleSensor';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b','phi_rel'];
      mo.parameters=list([],list(),[]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=['0'];
    x=standard_define([2 2],model,exprs,list([],0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style = [RotInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style = [RotOutputStyle(), RealOutputStyle()];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=-3;displayedLabel=Position"]
    end
endfunction
