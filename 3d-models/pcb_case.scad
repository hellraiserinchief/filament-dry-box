include <MCAD/boxes.scad>

$fn = 50;

pcb_dim = [ 90, 70, 1.6];
hole_size = 2.4;

//height of case bottom
h = 26;
//height of base top
h_t = 5;

pcb_ht = 10;

//pcb_case_top();
pcb_case_bottom();
pcb_case_top();

//pcb(0);
//_pcb_holes(1,10);

module pcb_case_bottom()
{
    difference()
    {
        union()
        {
            _pcb_case_bottom();
            _pcb_holes(3,pcb_ht);
        }
        cube(pcb_dim-[20,20,-10], center = true);
        translate([pcb_dim.x/2-5,0,0]) cylinder(r=3/2, h = 10);
        _pcb_holes(2/2,pcb_ht);
        translate([-pcb_dim.x/2+5,0,0]) cylinder(r=3/2, h = 10);
        _pcb_holes(2/2,pcb_ht);
        pcb(pcb_ht);
    }
}

module _pcb_case_bottom()
{
    
    translate([0,0,(h+pcb_dim[2]+pcb_ht)/2]) difference()
    {
        roundedBox([pcb_dim.x+10, pcb_dim.y+10, h+pcb_dim.z+10], 5, true);
        translate([0,0,3]) roundedBox([pcb_dim.x+8, pcb_dim.y+8, h+pcb_dim.z+10], 5, true);
    }
}

module pcb_case_top()
{
    difference()
    {
       _pcb_case_top(h+pcb_dim.z+pcb_ht);
       pcb(pcb_ht);
    }
}

module _pcb_case_top(ht)
{
    translate([0,0,h_t/2-2 + ht]) difference()
    {
        roundedBox([pcb_dim.x+12, pcb_dim.y+12, h_t], 5, true);
        translate([0,0,-h_t+2]) roundedBox([pcb_dim.x+10.05, pcb_dim.y+10.05, h_t], 5, true);
    }
}

module pcb(ht)
{
    translate([-pcb_dim.x/2, -pcb_dim.y/2,ht]) 
    {
        cube( pcb_dim );
        translate([pcb_dim.x - 14, 0, pcb_dim.z]) cube([14,19,24]);
        for( i = [ 0:4 ] )
            translate([pcb_dim.x - 14, i*4, pcb_dim.z]) cube([30,2,24]);
        translate([-10, 10, pcb_dim.z+10]) cube([12,12,11]);
        translate([57, 14/2, pcb_dim.z]) cylinder(r = 14/2, h = 40);
        translate([3.5,38, pcb_dim.z]) cube([71.1+2,24+2,30]);
        translate([pcb_dim.x, 30, pcb_dim.z+10]) rotate([0,90,0]) cylinder(r = 8/2, h = 10);
        
        
    }    
    
}

module _pcb_holes(hole_r, ht)
{
    translate([-pcb_dim.x/2, -pcb_dim.y/2,0]) 
    {
        translate([ 1+hole_size/2, 1+hole_size/2, 0 ] ) cylinder( h = ht, r = hole_r);
        translate([pcb_dim.x-hole_size/2-1, 1+hole_size/2]) cylinder( h = ht, r = hole_r);
        translate([ 1+hole_size/2, pcb_dim.y-1-hole_size/2, 0 ] ) cylinder( h = ht, r = hole_r);
        translate([pcb_dim.x-hole_size/2-1, pcb_dim.y-hole_size/2-1]) cylinder( h = ht, r = hole_r);
    }
}