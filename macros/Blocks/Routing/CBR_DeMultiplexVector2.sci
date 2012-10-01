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

function [x,y,typ]=CBR_DeMultiplexVector2(job,arg1,arg2)
x=[];y=[];typ=[];
select job
  case 'plot' then
    n1=arg1.graphics.exprs(1);
    n2=arg1.graphics.exprs(2);
    n1=strcat(sci2exp(double(evstr(n1))));
    n2=strcat(sci2exp(double(evstr(n2))));
    standard_draw(arg1,%f,_CBR_DeMultiplex2_dp);
  case 'getinputs' then
    [x,y,typ]=_CBR_DeMultiplex2_ip(arg1);
  case 'getoutputs' then
    [x,y,typ]=_CBR_DeMultiplex2_op(arg1);
  case 'getorigin' then
    [x,y]=standard_origin(arg1);
  case 'set' then
    x=arg1;
    graphics=arg1.graphics;exprs=graphics.exprs;
    model=arg1.model;
    while %t do
      [ok,n1,n2,exprs]=..
        scicos_getvalue(['';'CBR_DeMultiplexVector2';'';'DeMultiplexer block for two output connectors';''],..
        [' n1 [-] : dimension of output signal connector 1';' n2 [-] : dimension of output signal connector 2'],..
        list('intvec',1,'intvec',1),exprs);
      if ~ok then break, end
      model.equations.parameters(2)=list(int32(n1),int32(n2))
      model.in=[n1 + n2];
      model.out=[n1;n2];
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model;
      break
    end
  case 'define' then
    n1=1;
    n2=1;
    model=scicos_model();
    model.sim='Coselica';
    model.blocktype='c';
    model.dep_ut=[%t %f];
    model.in=[n1 + n2];
    model.out=[n1;n2];
    mo=modelica();
      mo.model='Coselica.Blocks.Routing.DeMultiplexVector2';
      mo.inputs=['u'];
      mo.outputs=['y1','y2'];
      mo.parameters=list(['n1','n2'],..
                         list(int32(n1),int32(n2)),..
                         [0,0]);
    model.equations=mo;
    exprs=[strcat(sci2exp(n1));strcat(sci2exp(n2))];
    gr_i=[];
    x=standard_define([2 2],model,exprs,list(gr_i,0));
    x.graphics.in_implicit=['I'];
    x.graphics.in_style=[RealInputStyle()];
    x.graphics.out_implicit=['I','I'];
    x.graphics.out_style=[RealOutputStyle(), RealOutputStyle()];
  end
endfunction
