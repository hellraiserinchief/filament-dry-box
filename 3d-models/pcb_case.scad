include <MCAD/boxes.scad>
include <MCAD/nuts_and_bolts.scad>

$fn = 50;

pcb_dim = [ 90, 70, 10];
hole_size = 2.4;

//height of case bottom
h = 24;
//height of base top
h_t = 5;

pcb_case_top();
//pcb_case_bottom();
//pcb_case_top();

//pcb(10);
//_pcb_holes(1,10);

module pcb_case_bottom()
{
    difference()
    {
        union()
        {
            _pcb_case_bottom();
            _pcb_holes(5,10);
        }
        _pcb_holes(2/2,10);
        pcb(10);
    }
}

module _pcb_case_bottom()
{
    
    translate([0,0,(h+pcb_dim[2]+10)/2]) difference()
    {
        roundedBox([pcb_dim[0]+10, pcb_dim[1]+10, h+pcb_dim[2]+10], 5, true);
        translate([0,0,3]) roundedBox([pcb_dim[0]+8, pcb_dim[1]+8, h+pcb_dim[2]+10], 5, true);
    }
}

module pcb_case_top()
{
    difference()
    {
       _pcb_case_top(h)
       #pcb(20);
    }
}

module _pcb_case_top(ht)
{
    translate([0,0,h_t/2-2 + ht]) difference()
    {
        roundedBox([pcb_dim[0]+12, pcb_dim[1]+12, h_t], 5, true);
        translate([0,0,-h_t+2]) roundedBox([pcb_dim[0]+10.05, pcb_dim[1]+10.05, h_t], 5, true);
    }
}

module pcb(ht)
{
    translate([-pcb_dim[0]/2, -pcb_dim[1]/2,ht]) 
    {
        cube( pcb_dim );
        translate([pcb_dim[0] - 14, 0, ht]) cube([14,19,24]);
        for( i = [ 0:4 ] )
            translate([pcb_dim[0] - 14, i*4, ht]) cube([30,2,21]);
        
        translate([-10, 10, ht+10]) cube([12,12,11]);
        translate([51, 14/2, ht]) cylinder(r = 14/2, h = 40);
        translate([3.5,38, ht]) cube([71.1+2,24+2,30]);
        translate([pcb_dim[0], 30, ht]) rotate([0,90,0]) cylinder(r = 8/2, h = 10);
    }    
    
}

module _pcb_holes(hole_r, ht)
{
    translate([-pcb_dim[0]/2, -pcb_dim[1]/2,0]) 
    {
        translate([ 1+hole_size/2, 1+hole_size/2, 0 ] ) cylindepcb_case_topr( h = ht, r = hole_r);
            translate([pcb_dim[0]-hole_size/2-1, 1+hole_size/2]) cylinder( h = ht, r = hole_r);
            translate([ 1+hole_size/2, pcb_dim[1]-1-hole_size/2, 0 ] ) cylinder( h = ht, r = hole_r);
            translate([pcb_dim[0]-hole_size/2-1, pcb_dim[1]-hole_size/2-1]) cylinder( h = ht, r = hole_r);
    }
}