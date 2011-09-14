// Coselica Toolbox for Scicoslab
// Copyright (C) 2010  Dirk Reusch, Kybernetik Dr. Reusch
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

function [] = _CMTS_ConstantForce_dp( o )
  
  xf = 40;
  yf = 40;
  
  [orig,sz,orient]=(o.graphics.orig,o.graphics.sz,o.graphics.flip)

  inout = 0.6*[ -1  -1
                 1  -1
                 1   1
                -1   1 ] * diag( [ xf/10, yf/10 ] );
             
  if orient then
    // output (right)
    xpoly(inout(:,1)+ones(4,1)*(orig(1)+sz(1)+xf/10),..
          inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),"lines",1);      
    e=gce();
    e.foreground=color(0,191,0);
    e.thickness=0.25;
  else
    // output (left)
    xpoly(inout(:,1)+ones(4,1)*(orig(1)-xf/10),..
          inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),"lines",1);
    e=gce();
    e.foreground=color(0,191,0);
    e.thickness=0.25;
end

  // support (bottom)
  xfpoly(inout(:,1)+ones(4,1)*(orig(1)+sz(1)/2),..
         inout(:,2)+ones(4,1)*(orig(2)-yf/15),1);      
  e=gce();
  e.foreground=color(0,191,0);
  e.background=color(0,191,0);
  e.thickness=0.25;

endfunction

