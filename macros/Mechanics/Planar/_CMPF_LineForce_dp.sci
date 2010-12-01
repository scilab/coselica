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

function [] = _CMPF_LineForce_dp( o )
  
  xf = 40;
  yf = 40;
  
  [orig,sz,orient]=(o.graphics.orig,o.graphics.sz,o.graphics.flip)

  // set port shape (planar mechanical frame)
  inout = 0.6*[ -1  -1
                 1  -1
                 1   1
                -1   1 ] * diag( [ xf/20, yf/7 ] );
                
  // set port shape (translational mechanical flange)
  inout2 = 0.5*[ -1  -1
                 1  -1
                 1   1
                -1   1 ] * diag( [ xf/10, yf/10 ] );
                
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
    
    // input flange_a (left)
    xpoly(inout2(:,1)+ones(4,1)*(orig(1)+xf/5),..
          inout2(:,2)+ones(4,1)*(orig(2)+sz(2)+yf/20),"lines",1);
    e=gce();
    e.foreground=color(0,191,0);
    e.thickness=0.25;
    
    // output flange_b (right)
    xfpoly(inout2(:,1)+ones(4,1)*(orig(1)+sz(1)-xf/5),..
          inout2(:,2)+ones(4,1)*(orig(2)+sz(2)+yf/20),1);      
    e=gce();
    e.foreground=color(0,191,0);
    e.background=color(0,191,0);
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
    
    // input flange_a (right)
    xpoly(inout2(:,1)+ones(4,1)*(orig(1)+sz(1)-xf/5),..
          inout2(:,2)+ones(4,1)*(orig(2)+sz(2)+yf/20),"lines",1);
    e=gce();
    e.foreground=color(0,191,0);
    e.thickness=0.25;
    
    // output flange_b (left)
    xfpoly(inout2(:,1)+ones(4,1)*(orig(1)+xf/5),..
          inout2(:,2)+ones(4,1)*(orig(2)+sz(2)+yf/20),1);      
    e=gce();
    e.foreground=color(0,191,0);
    e.background=color(0,191,0);
    e.thickness=0.25;
  end
    
endfunction

