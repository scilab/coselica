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

function [x,y,typ]=CBR_Extractor(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    index=arg1.graphics.exprs(1);
    nin=arg1.graphics.exprs(2);
    index=strcat(sci2exp(double(evstr(index))));
    nin=strcat(sci2exp(double(evstr(nin))));
    standard_draw(arg1,%f,_MBI_SISO_dp);
  case 'getinputs' then
    [x,y,typ]=_MBI_SISO_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_MBI_SISO_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,index,nin,exprs]=..
        getvalue(['';'CBR_Extractor';'';'Extract scalar signal out of signal vector';''],..
        [' index [-] : Index of output signal (positive integer <= nin)',' nin [-] : Number of inputs'],..
        list('vec',1,'vec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(index,nin)
      index=double(index);
      nin=double(nin);
      model.in=[nin];
      model.out=[1];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    index=1;
    nin=1;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[nin];
    model.out=[1];
    index=int32(1);
    nin=int32(1);
    mo=modelica();
      mo.model='Coselica.Blocks.Routing.Extractor';
      mo.inputs=['u'];
      mo.outputs=['y'];
      mo.parameters=list(['index','nin'],..
                         list(index,nin),..
                         [0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(index));strcat(sci2exp(nin))];
    gr_i=[
          'if orient then';
          '  xx=orig(1);yy=orig(2);';
          '  ww=sz(1);hh=sz(2);';
          'else';
          '  xx=orig(1)+sz(1);yy=orig(2);';
          '  ww=-sz(1);hh=sz(2);';
          'end';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0,orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0-1),orig(2)+sz(2)*1,sz(1)*1,sz(2)*1);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,191);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*1.05,""""+model.label+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,255);';
          'e.font_foreground=color(0,0,255);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.225,orig(2)+sz(2)*0.75,sz(1)*0.2,sz(2)*0.5);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.225-0.2),orig(2)+sz(2)*0.75,sz(1)*0.2,sz(2)*0.5);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.202948;0.202948;0.222948;0.202948],yy+hh*[0.5095395;0.4895396;0.4995396;0.5095395]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.315;0.3743025;0.4293025],yy+hh*[0.51;0.564535;0.564535]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.31;0.38;0.43],yy+hh*[0.52;0.7;0.7]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0;0.3],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xarc(orig(1)+sz(1)*0.2747815,orig(2)+sz(2)*0.5229625,sz(1)*0.05,sz(2)*0.0474998,0,360*64);';
          'else';
          '  xarc(orig(1)+sz(1)*(1-0.2747815-0.05),orig(2)+sz(2)*0.5229625,sz(1)*0.05,sz(2)*0.0474998,0,360*64);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,127);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.31;0.375;0.43],yy+hh*[0.475;0.3;0.3]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.315;0.374651;0.429651],yy+hh*[0.49;0.435465;0.435465]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.430596;0.430596;0.450596;0.430596],yy+hh*[0.445;0.425;0.435;0.445]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.43;0.43;0.45;0.43],yy+hh*[0.71;0.69;0.7;0.71]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.430636;0.430636;0.450636;0.430636],yy+hh*[0.3098525;0.2898525;0.2998525;0.3098525]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.4300085;0.4300085;0.4500085;0.4300085],yy+hh*[0.5744005;0.5544005;0.5644005;0.5744005]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(255,255,255);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xrect(orig(1)+sz(1)*0.475,orig(2)+sz(2)*0.75,sz(1)*0.3,sz(2)*0.5);';
          'else';
          '  xrect(orig(1)+sz(1)*(1-0.475-0.3),orig(2)+sz(2)*0.75,sz(1)*0.3,sz(2)*0.5);';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(235,235,235);';
          'e.fill_mode=""on"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[1;0.625],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.45;0.525],yy+hh*[0.7;0.7]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.45;0.525],yy+hh*[0.565;0.565]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.45;0.525],yy+hh*[0.435;0.435]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.45;0.525],yy+hh*[0.3;0.3]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.625;0.525;0.525;0.625;0.625],yy+hh*[0.5;0.565;0.565;0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.fill_mode=""off"";';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*-0.25,orig(2)+sz(2)*-0.25,""index=""+string(index)+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1--0.25-1.5),orig(2)+sz(2)*-0.25,""index=""+string(index)+"""",sz(1)*1.5,sz(2)*0.2,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,0);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=['strokeColor=blue;fillColor=blue'];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=['strokeColor=lbue'];
  end
endfunction
