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

function [x,y,typ]=CEAS_Thyristor(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
     case 'set' then
      x=arg1;
      graphics=arg1.graphics;exprs=graphics.exprs;
      model=arg1.model;
      while %t do
          [ok,VDRM,VRRM,IDRM,VTM,IH,ITM,VGT,IGT,TON,TOFF,Vt,Nbv,exprs]=...
              getvalue(['CEAS_Thyristor';__('Simple Thyristor Model')],...
                       [__('VDRM [V] : Forward breakthrough voltage (>= 0)');...
                        __('VRRM [V] : Reverse breakthrough voltage (>= 0)');...
                        __('IDRM [A] : Saturation current');...
                        __('VTM [V] : Conducting voltage');...
                        __('IH [A] : Holding current');...
                        __('ITM [A] : Conducting current');...
                        __('VGT [V] : Gate trigger voltage');...
                        __('IGT [A] : Gate trigger current');...
                        __('TON [s] : Switch on time');...
                        __('TOFF [s] : Switch off time');...
                        __('Vt [V] : Voltage equivalent of temperature (kT/qn)');...
                        __('Nbv [-] : Reverse Breakthrough emission coefficient')],...
                       list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
          if ~ok then break, end
          model.equations.parameters(2)=list(VDRM,VRRM,IDRM,VTM,IH,ITM,VGT,IGT,TON,TOFF,Vt,Nbv)
          graphics.exprs=exprs;
          x.graphics=graphics;x.model=model;
          break
      end
     case 'define' then
      model=scicos_model();
      VDRM=100;
      VRRM=100;
      IDRM=0.1;
      VTM=1.7;
      IH=0.006;
      ITM=25;
      VGT=0.7;
      IGT=0.005;
      TON=0.000001;
      TOFF=0.000015;
      Vt=0.04;
      Nbv=0.74;
      model.sim='Coselica';
      model.blocktype='c';
      model.dep_ut=[%t %f];
      mo=modelica();
      mo.model='Coselica.Electrical.Analog.Semiconductors.Thyristor';
      mo.inputs=['Anode','Gate'];
      mo.outputs=['Cathode'];
      mo.parameters=list(['VDRM','VRRM','IDRM','VTM','IH','ITM','VGT','IGT','TON','TOFF','Vt','Nbv'],...
                         list(VDRM,VRRM,IDRM,VTM,IH,ITM,VGT,IGT,TON,TOFF,Vt,Nbv),...
                         [0,0,0,0,0,0,0,0,0,0,0,0]);
      model.equations=mo;
      model.in=ones(size(mo.inputs,'*'),1);
      model.out=ones(size(mo.outputs,'*'),1);
      exprs=[sci2exp(VDRM);sci2exp(VRRM);sci2exp(IDRM);sci2exp(VTM);sci2exp(IH);sci2exp(ITM);sci2exp(VGT);sci2exp(IGT);sci2exp(TON);sci2exp(TOFF);sci2exp(Vt);sci2exp(Nbv)];
      gr_i=[];
      x=standard_define([2 2],model,exprs,list(gr_i,0));
      x.graphics.in_implicit=['I','I'];
      x.graphics.in_style=[ElecInputStyle(), ElecInputStyle() ];
      x.graphics.out_implicit=['I'];
      x.graphics.out_style=[ElecOutputStyle()];
    end
endfunction
