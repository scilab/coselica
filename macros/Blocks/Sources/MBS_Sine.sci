// Coselica Toolbox for Scicoslab
// Copyright (C) 2009  Dirk Reusch, Kybernetik Dr. Reusch
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

function [x,y,typ]=MBS_Sine(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    amplitude=arg1.graphics.exprs(1);
    freqHz=arg1.graphics.exprs(2);
    phase=arg1.graphics.exprs(3);
    offset=arg1.graphics.exprs(4);
    startTime=arg1.graphics.exprs(5);
    standard_draw(arg1,%f,_MBI_SO_dp);
  case 'getinputs' then
    [x,y,typ]=_MBI_SO_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MBI_SO_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,amplitude,freqHz,phase,offset,startTime,exprs]=...
        getvalue(['';'MBS_Sine';'';'Generate sine signal';''],...
        [' amplitude [-] : Amplitude of sine wave',' freqHz [Hz] : Frequency of sine wave',' phase [rad] : Phase of sine wave',' offset [-] : Offset of output signal',' startTime [s] : Output = offset for time < startTime'],...
        list('vec',1,'vec',1,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(amplitude,freqHz,phase,offset,startTime)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    model=scicos_model();
    amplitude=1;
    freqHz=1;
    phase=0;
    offset=0;
    startTime=0;
    model.sim='MBS_Sine';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    mo=modelica();
      mo.model='MBS_Sine';
      mo.inputs=[];
      mo.outputs=['y'];
      mo.parameters=list(['amplitude','freqHz','phase','offset','startTime'],...
                         list(amplitude,freqHz,phase,offset,startTime),...
                         [0,0,0,0,0]);
    model.equations=mo;
    model.in=ones(size(mo.inputs,'*'),1);
    model.out=ones(size(mo.outputs,'*'),1);
    exprs=[sci2exp(amplitude);sci2exp(freqHz);sci2exp(phase);sci2exp(offset);sci2exp(startTime)];
    gr_i=[...
          'if orient then';...
          '  xx=orig(1);yy=orig(2);';...
          '  ww=sz(1);hh=sz(2);';...
          'else';...
          '  xx=orig(1)+sz(1);yy=orig(2);';...
          '  ww=-sz(1);hh=sz(2);';...
          'end';...
          'if orient then';...
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';...
          'else';...
          '  xrect(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,191);';...
          'e.background=color(255,255,255);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,255);';...
          'e.fill_mode=""off"";';...
          'xpoly(xx+ww*[0.1;0.1],yy+hh*[0.84;0.1]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.1;0.06;0.14;0.1],yy+hh*[0.95;0.84;0.84;0.95]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.background=color(192,192,192);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.05;0.84],yy+hh*[0.5;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.95;0.84;0.84;0.95],yy+hh*[0.5;0.54;0.46;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(192,192,192);';...
          'e.background=color(192,192,192);';...
          'e.fill_mode=""on"";';...
          'e.thickness=0.25;';...
          'xpoly(xx+ww*[0.1;0.1565;0.1925;0.2245;0.253;0.281;0.309;0.337;0.3655;0.3935;0.4255;0.46585;0.5505;0.5865;0.6185;0.6465;0.675;0.703;0.731;0.7595;0.7875;0.8195;0.86;0.9],yy+hh*[0.5;0.671;0.7655;0.832;0.873;0.8955;0.899;0.883;0.8485;0.797;0.7205;0.606;0.346;0.249;0.179;0.1345;0.108;0.1;0.112;0.1425;0.1905;0.264;0.376;0.5]);';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.thickness=0.25;';...
          'if orient then';...
          '  xstringb(orig(1)+sz(1)*-0.235,orig(2)+sz(2)*-0.26,""freqHz=""+string(freqHz)+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'else';...
          '  xstringb(orig(1)+sz(1)*(1--0.235-1.5),orig(2)+sz(2)*-0.26,""freqHz=""+string(freqHz)+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';...
          'end';...
          'e=gce();';...
          'e.visible=""on"";';...
          'e.foreground=color(0,0,0);';...
          'e.background=color(0,0,0);';...
          'e.fill_mode=""off"";';...
         ];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=[];
    x.graphics.out_implicit=['E'];
  end
endfunction
