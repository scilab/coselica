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

function [x,y,typ]=CMPJ_FreeMotion(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    initType=arg1.graphics.exprs(1);
    r_rel_a_start=arg1.graphics.exprs(2);
    v_rel_a_start=arg1.graphics.exprs(3);
    a_rel_a_start=arg1.graphics.exprs(4);
    phi_rel_start=arg1.graphics.exprs(5);
    w_rel_start=arg1.graphics.exprs(6);
    z_rel_start=arg1.graphics.exprs(7);
    standard_draw(arg1,%f,_CMPI_TwoFrames_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPI_TwoFrames_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPI_TwoFrames_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,initType,r_rel_a_start,v_rel_a_start,a_rel_a_start,phi_rel_start,w_rel_start,z_rel_start,exprs]=..
        getvalue(['';'CMPJ_FreeMotion';'';'Free motion joint (3 degrees-of-freedom, 6 states)';''],..
        [' initType [-] : Type of initial value for [r_rel_a,v_rel_a,a_rel_a,phi_rel,w_rel,z_rel] (0=guess,1=fixed)'; ..
        ' r_rel_a_start [m] : Initial values of r_rel_a (vector from origin of frame_a to origin of frame_b resolved in frame_a)'; ..
        ' v_rel_a_start [m/s] : Initial values of velocity v_rel_a = der(r_rel_a)'; ..
        ' a_rel_a_start [m/s2] : Initial values of acceleration a_rel_a = der(v_rel_a)';.. 
        ' phi_rel_start [rad] : Initial value of angle phi_rel to rotate frame_a into frame_b';.. 
        ' w_rel_start [rad/s] : Initial value of angular velocity w_rel = der(phi_rel) of frame_b with respect to frame_a'; ..
        ' z_rel_start [rad/s2] : Initial value of angular acceleration z_rel = der(w_rel) of frame_b with respect to frame_a'],..
        list('vec',6,'vec',2,'vec',2,'vec',2,'vec',1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[1];
      model.equations.parameters(2)=list(initType,r_rel_a_start,v_rel_a_start,a_rel_a_start,phi_rel_start,w_rel_start,z_rel_start)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    initType=[0,0,0,0,0,0];
    r_rel_a_start=[0,0];
    v_rel_a_start=[0,0];
    a_rel_a_start=[0,0];
    phi_rel_start=0;
    w_rel_start=0;
    z_rel_start=0;
    exprs=[strcat(sci2exp(initType));strcat(sci2exp(r_rel_a_start));strcat(sci2exp(v_rel_a_start));strcat(sci2exp(a_rel_a_start));strcat(sci2exp(phi_rel_start));strcat(sci2exp(w_rel_start));strcat(sci2exp(z_rel_start))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Joints.FreeMotion';
      mo.inputs=['frame_a'];
      mo.outputs=['frame_b'];
      mo.parameters=list(['initType','r_rel_a_start','v_rel_a_start','a_rel_a_start','phi_rel_start','w_rel_start','z_rel_start'],..
                         list(initType,r_rel_a_start,v_rel_a_start,a_rel_a_start,phi_rel_start,w_rel_start,z_rel_start),..
                         [0,0,0,0,0,0,0]);
    model.equations=mo;
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'xpoly(xx+ww*[0.07;0.13;0.255;0.415;0.595;0.7;0.795],yy+hh*[0.655;0.805;0.915;0.96;0.94;0.845;0.74]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(160,160,160);';
          'e.thickness=0.5;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.95;0.75;0.75;0.95],yy+hh*[0.5;0.6;0.4;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.845;0.745;0.885;0.845],yy+hh*[0.79;0.7;0.64;0.79]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*0.01,""""+model.label+"""",sz(1)*1.43,sz(2)*0.315,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.43),orig(2)+sz(2)*0.01,""""+model.label+"""",sz(1)*1.43,sz(2)*0.315,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,255);';
          'e.font_foreground=color(0,0,255);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.05,orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.05-0.1),orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.65,orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.65-0.1),orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.455,orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.455-0.1),orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.25,orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.25-0.1),orig(2)+sz(2)*0.525,sz(1)*0.1,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(192,192,192);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I'];
  end
endfunction
