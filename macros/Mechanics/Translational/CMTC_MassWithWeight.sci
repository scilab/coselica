// Coselica Toolbox for Scicoslab
// Copyright (C) 2009-2011  Dirk Reusch, Kybernetik Dr. Reusch
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

function [x,y,typ]=CMTC_MassWithWeight(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    m=arg1.graphics.exprs(1);
    initType=arg1.graphics.exprs(2);
    s_start=arg1.graphics.exprs(3);
    v_start=arg1.graphics.exprs(4);
    L=arg1.graphics.exprs(5);
    standard_draw(arg1,%f,_MMTI_Rigid_dp);
  case 'getinputs' then
    [x,y,typ]=_MMTI_Rigid_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MMTI_Rigid_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,m,initType,s_start,v_start,L,exprs]=..
        getvalue(['';'CMTC_MassWithWeight';'';'Sliding mass with inertia and gravitational force (=m*g)';''],..
        [' m [kg] : Mass of the sliding mass',' initType [-] : Type of initial value for [s,v] (0=guess,1=fixed)',' s_start [m] : Initial value for absolute position of center of mass',' v_start [m/s] : Initial value for absolute velocity of mass',' L [m] : length of component from left flange to right flange (= flange_b.s - flange_a.s)'],..
        list('vec',1,'vec',2,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(m,initType,s_start,v_start,L)
      model.in=[1];
      model.out=[1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    m=1;
    initType=[0,0];
    s_start=0;
    v_start=0;
    L=0;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Translational.Components.MassWithWeight';
      mo.inputs=['flange_a'];
      mo.outputs=['flange_b'];
      mo.parameters=list(['m','initType','s_start','v_start','L'],..
                         list(m,initType,s_start,v_start,L),..
                         [0,0,0,0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(m));strcat(sci2exp(initType));strcat(sci2exp(s_start));strcat(sci2exp(v_start));strcat(sci2exp(L))];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'xpoly(xx+ww*[0;0.225],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,127,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.775;1],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,127,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.225,orig(2)+sz(2)*0.65,sz(1)*0.555,sz(2)*0.3);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.225-0.555),orig(2)+sz(2)*0.65,sz(1)*0.555,sz(2)*0.3);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.75;0.6;0.6;0.75],yy+hh*[0.05;0.1;0;0.05]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(128,128,128);';
          'e.background=color(128,128,128);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.2;0.6],yy+hh*[0.05;0.05]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*0.725,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*0.725,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*0.125,""m=""+string(m)+"""",sz(1)*1.5,sz(2)*0.15,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*0.125,""m=""+string(m)+"""",sz(1)*1.5,sz(2)*0.15,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.335;0.533;0.533;0.65;0.533;0.533;0.335;0.335],yy+hh*[0.5165;0.5165;0.568;0.5;0.432;0.4835;0.4835;0.5165]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,127,0);';
          'e.background=color(215,215,215);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I'];
  end
endfunction
