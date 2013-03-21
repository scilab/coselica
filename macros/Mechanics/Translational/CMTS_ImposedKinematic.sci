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

function [x,y,typ]=CMTS_ImposedKinematic(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;
      exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,value,fixedframe,exprs] = ...
              getvalue(['CMTS_ImposedKinematic';__('Imposed Kinematic from fixed frame or not')],..
                       [__('Choose physical quantity : (0) position, (1) speed, (2) acceleration');...
                        __('Fixed frame (1 : Yes / 0 : No)')],..
                       list('vec',1,'vec',1),exprs);

          if ~ok then break, end

          //test error syntax
          if fixedframe<>1 & fixedframe<>0 then
              message(_('Choose 1 or 0 in order to specify fixed frame or not'));
              ok = %f
          end

          if value<>0 & value<>1 & value<>2 then
              message(_('Physical quantity must be 0, 1 or 2'));
              ok = %f
          end

          //no error
          if ok then
              graphics.exprs = exprs;
              if fixedframe==1 then
                  mo=modelica();
                  select value
                   case 0
                    mo.model='Coselica.Mechanics.Translational.Sources.Position0';
                    mo.inputs=['s_ref'];
                    style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position<br><br>"]
                   case 1
                    mo.model='Coselica.Mechanics.Translational.Sources.Speed0';
                    mo.inputs=['v_ref'];
                    style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Speed<br><br>"]
                   case 2
                    mo.model='Coselica.Mechanics.Translational.Sources.Accelerate0';
                    mo.inputs=['a_ref'];
                    style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Acceleration<br><br>"]
                  end
                  mo.outputs=['flange_b'];
                  mo.parameters=list([],list(),[]);
                  model.equations=mo;
                  model.in=[1];
                  model.out=[1];
                  x=standard_define([2 2],model,exprs,list([],0));
                  x.graphics.in_implicit=['I'];
                  x.graphics.in_style=[RealInputStyle()];
                  x.graphics.out_implicit=['I'];
                  x.graphics.out_style=[TransOutputStyle()];
                  x.graphics.style=style;
              else
                  mo=modelica();
                  select value
                   case 0
                    mo.model='Coselica.Mechanics.Translational.Sources.Position';
                    mo.inputs=['s_ref'];
                    style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=;displayedLabel=Position<br><br>"]
                   case 1
                    mo.model='Coselica.Mechanics.Translational.Sources.Speed';
                    mo.inputs=['v_ref'];
                    style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=;displayedLabel=Speed<br><br>"]
                   case 2
                    mo.model='Coselica.Mechanics.Translational.Sources.Accelerate';
                    mo.inputs=['a_ref'];
                    style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=;displayedLabel=Acceleration<br><br>"]
                  end
                  mo.outputs=['flange','support'];
                  mo.parameters=list([],list(),[]);
                  model.equations=mo;
                  model.in=[1];
                  model.out=[1;1];
                  x=standard_define([2 2],model,exprs,list([],0));
                  x.graphics.in_implicit=['I'];
                  x.graphics.in_style=[RealInputStyle()];
                  x.graphics.out_implicit=['I','I'];
                  x.graphics.out_style=[TransOutputStyle(), TransInputStyle()];
                  x.graphics.style=style;
              end
          end


          break
      end


     case 'define' then
      model=scicos_model();
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      model.in=[1];
      model.out=[1];
      mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Sources.Position0';
      mo.inputs=['s_ref'];
      mo.outputs=['flange_b'];
      mo.parameters=list([],list(),[]);
      model.equations=mo;
      exprs=['0';'1']; //default : position, fixed frame
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I'];
      x.graphics.in_style=[RealInputStyle()];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[TransOutputStyle()];
      x.graphics.style=["blockWithLabel;verticalLabelPosition=middle;verticalAlign=top;spacing=0;displayedLabel=Position<br><br>"]
    end
endfunction
