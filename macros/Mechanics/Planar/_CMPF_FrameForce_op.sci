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

function [x,y,typ] = _CMPF_FrameForce_op( o )
  
  xf=40;
  yf=40;
  
  [orig,sz,orient]=(o.graphics.orig,o.graphics.sz,o.graphics.flip);
  
  if orient then
    x1=orig(1)+sz(1)+xf/30;
  else
    x1=orig(1)-xf/30;
  end
  x2=orig(1)+sz(1)/2;

  y1=orig(2)+sz(2)/2;
  y2=orig(2)-yf/30;
  
  x=[x1,x2];
  y=[y1,y2];
  
  typ=[2,2];
  
endfunction

