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

function [x,y,typ]=CMPP_PointMass(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    m=arg1.graphics.exprs(1);
    standard_draw(arg1,%f,_CMPP_PointMass_dp);
  case 'getinputs' then
    [x,y,typ]=_CMPP_PointMass_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CMPP_PointMass_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,m,exprs]=..
        getvalue(['';'CMPP_PointMass';'';'Rigid body where body rotation and inertia is neglected (no states)';''],..
        [' m [kg] : Mass of mass point (m > 0)'],..
        list('vec',1),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[];
      model.equations.parameters(2)=list(m)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    m=1;
    exprs=[strcat(sci2exp(m))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Parts.PointMass';
      mo.inputs=['frame_a'];
      mo.outputs=[];
      mo.parameters=list(['m'],..
                         list(m),..
                         [0]);
    model.equations=mo;
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.145,orig(2)+sz(2)*-0.01,""m=""+string(m)+"""",sz(1)*1.305,sz(2)*0.23,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.145-1.305),orig(2)+sz(2)*-0.01,""m=""+string(m)+"""",sz(1)*1.305,sz(2)*0.23,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.14,orig(2)+sz(2)*0.775,""""+model.label+"""",sz(1)*1.3,sz(2)*0.275,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.14-1.3),orig(2)+sz(2)*0.775,""""+model.label+"""",sz(1)*1.3,sz(2)*0.275,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,255);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.25,orig(2)+sz(2)*0.75,sz(1)*0.5,sz(2)*0.5,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.25-0.5),orig(2)+sz(2)*0.75,sz(1)*0.5,sz(2)*0.5,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,127,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=[];
  end
endfunction
