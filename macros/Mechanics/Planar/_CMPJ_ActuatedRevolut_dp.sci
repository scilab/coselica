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

function [] = _CMPJ_ActuatedRevolut_dp( o )
  
  xf = 40;
  yf = 40;
  
  [orig,sz,orient]=(o.graphics.orig,o.graphics.sz,o.graphics.flip)

  // set port shape
  inout = 0.6*[ -1  -1
                 1  -1
                 1   1
                -1   1 ] * diag( [ xf/20, yf/7 ] );
  
  if orient then
    // input frame_a (left)
    xfpoly(inout(:,1)+ones(4,1)*(orig(1)-xf/30),..
           inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),1);
    e=gce();
    e.foreground=color(0,0,0);
    e.background=color(192,192,192);
    e.thickness=0.25;

    // output frame_b (right)
    xpoly(inout(:,1)+ones(4,1)*(orig(1)+sz(1)+xf/30),..
          inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),"lines",1);      
    e=gce();
    e.foreground=color(0,0,0);
    e.thickness=0.25;
    
    // input bearing (left)
    xarc( orig(1)+xf/7, orig(2)+sz(2)+yf/20, xf/10, yf/10, 0, 360*64 );
    e=gce();
    e.foreground=color(0,0,0);
    e.thickness=0.25;
  else
    // input frame_a (right)
    xfpoly(inout(:,1)+ones(4,1)*(orig(1)+sz(1)+xf/30),..
           inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),1);
    e=gce();
    e.foreground=color(0,0,0);
    e.background=color(192,192,192);
    e.thickness=0.25;
    
    // output frame_b (left)
    xpoly(inout(:,1)+ones(4,1)*(orig(1)-xf/30),..
          inout(:,2)+ones(4,1)*(orig(2)+sz(2)/2),"lines",1);
    e=gce();
    e.foreground=color(0,0,0);
    e.thickness=0.25;

    // input bearing (right)
    xarc( orig(1)+sz(1)-xf/4, orig(2)+sz(2)+yf/20, xf/10, yf/10, 0, 360*64 );
    e=gce();
    e.foreground=color(0,0,0);
    e.thickness=0.25;
  end

  // output axis (top center)
  xfarc( orig(1)+sz(1)/2-xf/20, orig(2)+sz(2)+yf/20, xf/10, yf/10, 0, 360*64 );
  e=gce();
  e.line_mode="on";
  e.foreground=color(0,0,0);
  e.background=color(192,192,192);
  e.thickness=0.25;
    
endfunction

