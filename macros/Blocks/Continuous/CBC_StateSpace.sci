// Coselica Toolbox for Xcos
// Copyright (C) 2011 - DIGITEO - Bruno JOFRET
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

function [x,y,typ]=CBC_StateSpace(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    nx=arg1.graphics.exprs(1);
    A=arg1.graphics.exprs(2);
    B=arg1.graphics.exprs(3);
    C=arg1.graphics.exprs(4);
    D=arg1.graphics.exprs(5);
    initType=arg1.graphics.exprs(6);
    x_start=arg1.graphics.exprs(7);
    y_start=arg1.graphics.exprs(8);
    nin=arg1.graphics.exprs(9);
    nout=arg1.graphics.exprs(10);
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
      [ok,nx,A,B,C,D,initType,x_start,y_start,nin,nout,exprs]=..
        getvalue(['';'CBC_StateSpace';'';'Linear state space system';''],..
        [' nx [-] : Number of states';' A [-] : Matrix A of state space model (e.g., A=[1, 0; 0, 1])';' B [-] : Matrix B of state space model (e.g., B=[1; 1])';' C [-] : Matrix C of state space model (e.g., C=[1, 1])';' D [-] : Matrix D of state space model';' initType [-] : Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)';' x_start [-] : Initial or guess values of states';' y_start [-] : Initial values of outputs (remaining states are in steady state if possible)';' nin [-] : Number of inputs';' nout [-] : Number of outputs'],..
        list('vec',1,'mat',[-1,-1],'mat',[-1,-1],'mat',[-1,-1],'mat',[-1,-1],'vec',1,'vec',-1,'vec',-1,'vec',1,'vec',1),exprs);
      if ~ok then break, end
    model.in=[nin];
    model.out=[nout];
      nx=int32(nx);
      initType=int32(initType);
      nin=int32(nin);
      nout=int32(nout);
      model.equations.parameters(2)=list(nx,A,B,C,D,initType,x_start,y_start,nin,nout)
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    nx=2;
    A=[1,0;0,1];
    B=[1;1];
    C=[1,1];
    D=0;
    initType=1;
    x_start=[0,0];
    y_start=0;
    nin=1;
    nout=1;
    exprs=[strcat(sci2exp(nx));strcat(sci2exp(A));strcat(sci2exp(B));strcat(sci2exp(C));strcat(sci2exp(D));strcat(sci2exp(initType));strcat(sci2exp(x_start));strcat(sci2exp(y_start));strcat(sci2exp(nin));strcat(sci2exp(nout))];
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[nin];
    model.out=[nout];
    mo=modelica();
      mo.model='Coselica.Blocks.Continuous.StateSpace';
      mo.inputs=['u'];
      mo.outputs=['y'];
    nx=int32(2);
    initType=int32(1);
    nin=int32(1);
    nout=int32(1);
      mo.parameters=list(['nx','A','B','C','D','initType','x_start','y_start','nin','nout'],..
                         list(nx,A,B,C,D,initType,x_start,y_start,nin,nout),..
                         [0,0,0,0,0,0,0,0,0,0]);
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
          '  xstringb(orig(1)+sz(1)*0.05,orig(2)+sz(2)*0.55,""A"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.05-0.4),orig(2)+sz(2)*0.55,""A"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.55,orig(2)+sz(2)*0.55,""B"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.55-0.4),orig(2)+sz(2)*0.55,""B"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.05,orig(2)+sz(2)*0.05,""C"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.05-0.4),orig(2)+sz(2)*0.05,""C"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'if orient then';
          '  xstringb(orig(1)+sz(1)*0.55,orig(2)+sz(2)*0.05,""D"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'else';
          '  xstringb(orig(1)+sz(1)*(1-0.55-0.4),orig(2)+sz(2)*0.05,""D"",sz(1)*0.4,sz(2)*0.4,""fill"");';
          'end';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(0,0,127);';
          'e.background=color(0,0,0);';
          'e.font_foreground=color(0,0,0);';
          'e.fill_mode=""off"";';
          'xpoly(xx+ww*[0.5;0.5],yy+hh*[0.05;0.95]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(192,192,192);';
          'e.thickness=0.25;';
          'e.line_style=1;';
          'xpoly(xx+ww*[0.05;0.95],yy+hh*[0.5;0.5]);';
          'e=gce();';
          'e.visible=""on"";';
          'e.foreground=color(192,192,192);';
          'e.thickness=0.25;';
          'e.line_style=1;'
         ];

    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[RealInputStyle()];
    x.graphics.out_implicit=['I'];
    x.graphics.out_style=[RealOutputStyle()];
  end
endfunction
