$fn=100;

height = 10;
width = 50;
depth = 10;
rodDia = 8;
screwDia = 3;

outHeight = 6;
outDia = 8;

module arm() difference() {
    difference() {
        union() {
            translate([width/2, 0, 0]) cylinder(height/2, depth/2, depth/2, true);
            translate([-width/2, 0, 0]) cylinder(height/2, depth/2, depth/2, true);
            cube([ width, depth, height/2], true);
        }
        translate([width/2, 0, 0]) cylinder(height/2,       screwDia/2, screwDia/2, true);
    }
    translate([-width/2, 0, 0]) cylinder(height/2,       screwDia/2, screwDia/2, true);
}

module center() difference() {
       translate([0,0,-height/4]) cylinder( height, rodDia, rodDia );
       union() {
            translate([0,0,height/2]) cylinder( height/2, rodDia/2, rodDia/2, true );
           rotate([0,0,90]) translate([-rodDia/2,0,height/2]) cube([ rodDia, rodDia, height/2], true );
       }
   }
   
   
module outlet() difference() {
   difference() {
    difference() {
        union() {
            translate([width/4, 0, 0]) cylinder(outHeight, depth*0.75, depth*0.75, true);
            translate([-width/4, 0, 0]) cylinder(outHeight, depth*0.75, depth*0.75, true);
            cube([ width/2, depth*1.5, outHeight], true);
        }
        translate([width/4, 0, 0]) cylinder(outHeight,       screwDia/2, screwDia/2, true);
    }
    translate([-width/4, 0, 0]) cylinder(outHeight,       screwDia/2, screwDia/2, true);
    }
    cylinder(outHeight, outDia/2, outDia/2, true);
}
      
module externalHolder() union() {
    rotate([0,0,45]) {
        arm();
    }
    rotate([0,0,-45]) {
        arm();
    }
}
  
module rodHolder() union() {
    externalHolder();
    center();
}

arm();

