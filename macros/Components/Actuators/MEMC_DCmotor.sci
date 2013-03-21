// Coselica Toolbox for Xcos
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
// Copyright (C) 2009, 2010  Dirk Reusch, Kybernetik Dr. Reusch
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

function [x,y,typ]=MEMC_DCmotor(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
//    k=arg1.graphics.exprs(1);
//    standard_draw(arg1,%f,_CEAB_EMF_dp);
  case 'getinputs' then
//    [x,y,typ]=_CEAB_EMF_ip(arg1);
  case 'getoutputs' then
//    [x,y,typ]=_CEAB_EMF_op(arg1);
  case 'getorigin' then
//    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,R,L,k,Jrotor,fixedframe,exprs]=...
        getvalue(['MEMC_DCmotor';__('DC motor with permanent magnet')],...
        [__('R [Ohm] : Resistance');...
         __('L [H] : inductance');...
         __('k [Nm/A] : constant fcem');...
         __('Jrotor [kg.m^2] : rotor inertial momentum');...
         __('Fixed frame (1 : Yes / 0 : No)')] ,...
        list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end

            //test error syntax
      if fixedframe<>1 & fixedframe<>0 then
          message(_('Choose 1 or 0 in order to specify fixed frame or not'));
          ok = %f
      end

      //no error
      if ok then
          graphics.exprs=exprs;
          if fixedframe==1 then //fixed stator
                mo=modelica();
                mo.model='Modelica.Electrical.Machines.Components.DCmotor0';
                mo.inputs=['p','n'];
                mo.outputs=['rotor'];
                mo.parameters=list(['R','L','k','Jrotor'],...
                                     list(R,L,k,Jrotor),...
                                     [0,0,0,0]);
                model.equations=mo;
                model.in=ones(size(mo.inputs,'*'),1);
                model.out=ones(size(mo.outputs,'*'),1);
                x=standard_define([2 2],model,exprs,[]);
                x.graphics.in_implicit=['I','I'];
                x.graphics.in_style=[ElecInputStyle(),ElecOutputStyle()];
                x.graphics.out_implicit=['I'];
                x.graphics.out_style=[RotOutputStyle()];
          else
                mo=modelica();
                mo.model='Modelica.Electrical.Machines.Components.DCmotor';
                mo.inputs=['p','n'];
                mo.outputs=['rotor','stator'];
                mo.parameters=list(['R','L','k','Jrotor'],...
                                     list(R,L,k,Jrotor),...
                                     [0,0,0,0]);
                model.equations=mo;
                model.in=ones(size(mo.inputs,'*'),1);
                model.out=ones(size(mo.outputs,'*'),1);
                x=standard_define([2 2],model,exprs,[]);
                x.graphics.in_implicit=['I','I'];
                x.graphics.in_style=[ElecInputStyle(),ElecOutputStyle()];
                x.graphics.out_implicit=['I','I'];
                x.graphics.out_style=[RotOutputStyle(),RotInputStyle()];
          end
      end

      break
    end
  case 'define' then
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    R=0.05;
    L=0.001;
    k=0.64;
    Jrotor=0.15;
    fixed=1;
    mo=modelica();
      mo.model='Modelica.Electrical.Machines.Components.DCmotor0';
      mo.inputs=['p','n'];
      mo.outputs=['rotor'];
      mo.parameters=list(['R','L','k','Jrotor'],...
                         list(R,L,k,Jrotor),...
                         [0,0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(R);sci2exp(L);sci2exp(k);sci2exp(Jrotor);sci2exp(fixed)];

    x=standard_define([2 2],model,exprs,[]);
    x.graphics.in_implicit=['I','I'];
    x.graphics.in_style=[ElecInputStyle(),ElecOutputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RotOutputStyle()];
  end
endfunction
