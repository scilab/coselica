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

function [] = _MMR_IdealGearR2T_dp( o )
  
  xf = 40;
  yf = 40;
  
  [orig,sz,orient]=(o.graphics.orig,o.graphics.sz,o.graphics.flip)

  // set port shape
  inout = 0.5*[ -1  -1
                 1  -1
                 1   1
                -1   1 ] * diag( [ xf/10, yf/10 ] );
  
  if orient then
    // R: flange_a (left)
    xfarc( orig(1)-xf/20, orig(2)+sz(2)/2+yf/20, xf/10, yf/10, 0, 360*64 );
    e=gce();
    e.line_mode="on";
    e.foreground=color(0,0,0);
    e.background=color(192,192,192);
    e.thickness=0.25;
    
    // R: bearingR (bottom left)
    xfarc( orig(1)+sz(1)*0.15, orig(2)-yf/10, xf/10, yf/10, 0, 360*64 );
    e=gce();
    e.line_mode="on";
    e.foreground=color(0,0,0);
    e.background=color(192,192,192);
    e.thickness=0.25;
    
    // T: flange_b (right)
    xpoly(inout(:,1)+ones(4,1)*(orig(1)+sz(1)),..
          inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),"lines",1);      
    e=gce();
    e.foreground=color(0,191,0);
    e.thickness=0.25;
    
    // T: bearingT (bottom right)
    xfpoly(inout(:,1)+ones(4,1)*(orig(1)+sz(1)*0.80),..
           inout(:,2)+ones(4,1)*(orig(2)-yf/7),1);      
    e=gce();
    e.foreground=color(0,191,0);
    e.background=color(0,191,0);
    e.thickness=0.25;
  else
    // R: flange_a (right)
    xfarc( orig(1)+sz(1)-xf/20, orig(2)+sz(2)/2+yf/20, xf/10, yf/10, 0, 360*64 );
    e=gce();
    e.line_mode="on";
    e.foreground=color(0,0,0);
    e.background=color(192,192,192);
    e.thickness=0.25;
    
    // R: bearingR (bottom right)
    xfarc( orig(1)+sz(1)*0.85-xf/10, orig(2)-yf/10, xf/10, yf/10, 0, 360*64 );
    e=gce();
    e.line_mode="on";
    e.foreground=color(0,0,0);
    e.background=color(192,192,192);
    e.thickness=0.25;
    
    // T: flange_b (left)
    xpoly(inout(:,1)+ones(4,1)*(orig(1)),..
          inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),"lines",1);      
    e=gce();
    e.foreground=color(0,191,0);
    e.thickness=0.25;
    
    // T: bearingT (bottom left)
    xfpoly(inout(:,1)+ones(4,1)*(orig(1)+sz(1)*0.20),..
           inout(:,2)+ones(4,1)*(orig(2)-yf/7),1);      
    e=gce();
    e.foreground=color(0,191,0);
    e.background=color(0,191,0);
    e.thickness=0.25;
  end

endfunction

