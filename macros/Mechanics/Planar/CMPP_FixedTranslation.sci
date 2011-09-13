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

function [x,y,typ]=CMPP_FixedTranslation(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    r=arg1.graphics.exprs(1);
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
      [ok,r,exprs]=..
        getvalue(['';'CMPP_FixedTranslation';'';'Fixed translation of frame_b with respect to frame_a';''],..
        [' r [m] : Vector from frame_a to frame_b resolved in frame_a'],..
        list('vec',2),exprs);
      if ~ok then break, end
    model.in=[1];
    model.out=[1];
      model.equations.parameters(2)=list(r)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    r=[0,0];
    exprs=[strcat(sci2exp(r))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[1];
    model.out=[1];
    mo=modelica();
      mo.model='Coselica.Mechanics.Planar.Parts.FixedTranslation';
      mo.inputs=['frame_a'];
      mo.outputs=['frame_b'];
      mo.parameters=list(['r'],..
                         list(r),..
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
          '  xrect(orig(1)+sz(1)*0.005,orig(2)+sz(2)*0.525,sz(1)*1,sz(2)*0.05);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.005-1),orig(2)+sz(2)*0.525,sz(1)*1,sz(2)*0.05);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.155,orig(2)+sz(2)*0.705,""""+model.label+"""",sz(1)*1.3,sz(2)*0.3,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.155-1.3),orig(2)+sz(2)*0.705,""""+model.label+"""",sz(1)*1.3,sz(2)*0.3,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.165,orig(2)+sz(2)*0.14,""r=""+string(r)+"""",sz(1)*1.3,sz(2)*0.25,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.165-1.3),orig(2)+sz(2)*0.14,""r=""+string(r)+"""",sz(1)*1.3,sz(2)*0.25,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.055,orig(2)+sz(2)*0.565,""a"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.055-0.18),orig(2)+sz(2)*0.565,""a"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(128,128,128);';
          'e.font_foreground=color(128,128,128);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.785,orig(2)+sz(2)*0.57,""b"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.785-0.18),orig(2)+sz(2)*0.57,""b"",sz(1)*0.18,sz(2)*0.125,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(128,128,128);';
          'e.font_foreground=color(128,128,128);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.out_implicit=['I'];
    x.graphics.in_style=['fillColor=#C0C0C0;strokeColor=#C0C0C0'];
    x.graphics.out_style=['fillColor=white;strokeColor=#C0C0C0'];
  end
endfunction
