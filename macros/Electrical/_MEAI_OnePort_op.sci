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

function [x,y,typ] = _MEAI_OnePort_op( o )
  
  xf=40;
  yf=40;
  
  [orig,sz,orient]=(o.graphics.orig,o.graphics.sz,o.graphics.flip);
  
  if orient then
    x=orig(1)+sz(1)+xf/15;
  else
    x=orig(1)-xf/15;
  end

  y=orig(2)+sz(2)/2;

  typ=2;
  
endfunction

