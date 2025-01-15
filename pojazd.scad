include <silnik.scad>
include <kolo.scad>

include <BOSL/constants.scad>
use <BOSL/metric_screws.scad>

for_export=false;

base_width = 65.2;
base_height = 65.2;
base_thickness = 2;

cable_hole_diameter=5;
cable_hole_length=8;
cable_hole_distance=2;
cable_hole_edge_offset=9;

stand_height = 18;

screw_wall_offset = 0;

show_screw_in_screw_wall=false;
screw_length_in_screw_wall=5;
screw_wall_connector_len = 10;

screw_conn_diameter = 1.6;
screw_conn_diameter_clearence = 0.4;

module MotorAndWheel() {
//    translate([18,0,0])
//    rotate([0,90,180])
//    {
//        Wheel(25, 21);
//        color("black")
//        Torus(29/2,4);
//    };

    rotate([0,90,0])
    Motor();
};

module MotorHolder(length=8) {
    difference() {
        union() {
            intersection() {
                cylinder(length, 20/2, 20/2, center=true);
                cube([20,15,20],center=true);
            }
            translate([0,15/4,0])
            cube([20,15/2,length], center=true);
        }
        intersection() {
            cylinder(20, 16/2, 16/2, center=true);
            cube([16,13,20],center=true);
        }
    }
};

module ScrewCylinder(height=15, screw_length=10, diameter=6, screw_diameter=3, chamfer_len=1.5, chamfer_diameter=4) {
    color("blue")
    difference() {
        cylinder(height, diameter/2, diameter/2);
        
        translate([0,0,height-screw_length/2+0.5])
        cylinder(screw_length+1, screw_diameter/2, screw_diameter/2, center=true);
        
        translate([0,0,height-chamfer_len/2+0.001])
        cylinder(chamfer_len, screw_diameter/2, chamfer_diameter/2, center=true);
    }
};

module CableHole() {
    radius = cable_hole_diameter / 2;
    length = cable_hole_length;
    thickness = base_thickness + 1;
    
    hull() {
        translate([0,length/2,0])
        cylinder(thickness, radius, radius, center=true);

        translate([0,-length/2,0])
        cylinder(thickness, radius, radius, center=true);
    }  
};

module BatteryWall(front) {
    thickness = 2;
    width = 20;
    height = 10;
    bevel_radius = 1;
    
    union() {
        hull() {
            translate([-width/2 + height/2, 0, 0])
            rotate([90,0,0])
            cylinder(thickness, height/2, height/2, center=true);
            
            translate([width/2 - height/2, 0, 0])
            rotate([90,0,0])
            cylinder(thickness, height/2, height/2, center=true);
        }
        translate([0,0,-height/4])
        cube([width, thickness, height/2], center=true);
        
        rotate([0,0,front ? 180 : 0])
        translate([0,-thickness/2-bevel_radius,-height/2+bevel_radius])
        difference() {
            translate([0,bevel_radius/2, -bevel_radius/2])
            cube([width, bevel_radius, bevel_radius], center=true);
            
            rotate([0,90,0])
            cylinder(width+1, bevel_radius, bevel_radius, center=true);
        }
    }
};

module ScrewWallConnectors(as_holes=false, skip=[]) {
    length = screw_wall_connector_len;
    diameter = screw_conn_diameter + (as_holes ? screw_conn_diameter_clearence : 0);
    count = 4;
    distance = length / (count - 1);
    
    
    offset = as_holes ? 1 : 0;
    
    for(i = [0:count-1]) {
        if(search(i, skip) == []) {
            translate([-length/2+distance*i,0,0])
            cylinder(base_thickness+offset, diameter/2, diameter/2, center=true);
        }
    }
}

module ScrewWall(/*skip_connectors=[],*/ left_limiter=false, half=false) {
    
    offset_top = screw_wall_offset;
    screw_clearance=2.4;
    head_clearence=7;
    thickness=3;
    
    width = 15;
    height = 12;
    engine_hole = 6;
    
    clipper_thickness = 1;
    base_thickness_clearence=0.1;
    
    union() {
        translate([0,-clipper_thickness/2,0])
        difference() {
            union() {
                intersection() {
                    difference() {
                        translate([0,0,offset_top/2])
                        cube([width, thickness + clipper_thickness, height + offset_top], center=true);
                        rotate([0,-30,0]) {
                            translate([-5,0,0])
                            rotate([90,0,0])
                            cylinder(thickness+clipper_thickness+1, screw_clearance/2, screw_clearance/2, center=true);
                            
                            translate([-5,-thickness/2-0.5,0])
                            rotate([90,0,0])
                            cylinder(clipper_thickness + 1, head_clearence/2, head_clearence/2, center=true);
                            
                            translate([5,0,0])
                            rotate([90,0,0])
                            cylinder(thickness+clipper_thickness+1, screw_clearance/2, screw_clearance/2, center=true);
                            
                            translate([5,-thickness/2-0.5,0])
                            rotate([90,0,0])
                            cylinder(clipper_thickness + 1, head_clearence/2, head_clearence/2, center=true);
                        }
                        rotate([90,0,0])
                        cylinder(thickness+clipper_thickness+1, engine_hole/2, engine_hole/2, center=true);
                    }
                    
                    union() {
                        translate([0,0,12/2])
                        cube([width, thickness + clipper_thickness + 1, height], center=true);
                        rotate([90,0,0])
                        cylinder(thickness + clipper_thickness + 1, width/2, 15/2, center=true);
                    }
                }
            }
        }
        
        if(show_screw_in_screw_wall) {
            rotate([0,-30,0]) {
                rotate([90,0,0])
                translate([-5,0,(thickness + clipper_thickness)/2])
                metric_bolt(headtype="hex", size=2, l=screw_length_in_screw_wall, details=false, phillips="#2", pitch=0);
                
                rotate([90,0,0])
                translate([5,0,(thickness + clipper_thickness)/2])
                metric_bolt(headtype="hex", size=2, l=screw_length_in_screw_wall, details=false, phillips="#2", pitch=0);
            }
        }
        
//        color("orange")
//        translate([0,0,height/2+base_thickness/2])
//        ScrewWallConnectors(false, skip_connectors);
        translate([0, -thickness/2-clipper_thickness/2, height/2+base_thickness/2+base_thickness_clearence/2])
        cube([width, clipper_thickness, base_thickness+base_thickness_clearence], center=true);
        
        translate([clipper_thickness/2 * (left_limiter ? -1 : 1) + (half ? (width / 4) * (left_limiter ? -1 : 1) : 0), -thickness/2+clipper_thickness, height/2+base_thickness+clipper_thickness/2+base_thickness_clearence])
        cube([(half ? 0.5 : 1) * width+clipper_thickness, thickness + clipper_thickness, clipper_thickness], center=true);
        
        translate([(width/2 + clipper_thickness/2) * (left_limiter ? -1 : 1), -clipper_thickness/2, height/2+clipper_thickness-1+base_thickness_clearence/2])
        cube([clipper_thickness, thickness + clipper_thickness, base_thickness+base_thickness_clearence+2], center=true);
        
        difference() {
            translate([width/2 * (left_limiter ? -1 : 1), -clipper_thickness/2, height/2-2*clipper_thickness])
            rotate([0,45,0])
            cube([clipper_thickness*sqrt(2), thickness + clipper_thickness, clipper_thickness*sqrt(2)], center=true);
            
            rotate([0,-30,0]){
                translate([-5,-thickness/2-clipper_thickness,0])
                rotate([90,0,0])
                cylinder(clipper_thickness + 1, head_clearence/2, head_clearence/2, center=true);
                
                translate([5,-thickness/2-clipper_thickness,0])
                rotate([90,0,0])
                cylinder(clipper_thickness + 1, head_clearence/2, head_clearence/2, center=true);
            }
        }
    }
}

module PCBSimplification() {
    difference() {
        cube([base_width,base_height,2],center=true);
        
        translate([base_width/2-3,base_height/2-47,0])
        cylinder(3, 3.4/2, 3.4/2, center=true);
        
        translate([-base_width/2+3,base_height/2-51,0])
        cylinder(3, 3.4/2, 3.4/2, center=true);
        
        translate([-base_width/2+3,base_height/2-11,0])
        cylinder(3, 3.4/2, 3.4/2, center=true);
    }
};

module BatteryPlaceholder() {
    cube([59.2,37.2,9.2],center=true);
};

module CableGuide() {
    width = 5.4;
    height = 3.4;
    thickness = 1;
    length = 3;
    inside_bevel_radius=0.15;
    
    union() {
        translate([0,height+thickness/2,0])
        hull() {
            translate([-width/2-thickness/2,0,0])
            cylinder(length, thickness/2, thickness/2, center=true);
        
            translate([width/2+thickness/2,0,0])
            cylinder(length, thickness/2, thickness/2, center=true);
        }
            
        translate([-width/2-thickness/2,height/2+thickness/4,0])
        cube([thickness, height+thickness/2, length], center=true);
        
        translate([width/2+thickness/2,height/2+thickness/4,0])
        cube([thickness, height+thickness/2, length], center=true);
            
        translate([-width/2+inside_bevel_radius, height-inside_bevel_radius, 0])
        difference() {
            translate([-inside_bevel_radius/2, inside_bevel_radius/2, 0])
            cube([inside_bevel_radius,inside_bevel_radius,length], center=true);
            cylinder(length+1, inside_bevel_radius, inside_bevel_radius, center=true);
        }
          
        mirror([1,0,0]) {
            translate([-width/2+inside_bevel_radius, height-inside_bevel_radius, 0])
            difference() {
                translate([-inside_bevel_radius/2, inside_bevel_radius/2, 0])
                cube([inside_bevel_radius,inside_bevel_radius,length], center=true);
                cylinder(length+1, inside_bevel_radius, inside_bevel_radius, center=true);
            }
        }
    }
};

module Base() {
    difference() {
        cube([base_width,base_height,base_thickness],center=true);
        
        translate([base_width/2 - cable_hole_edge_offset, cable_hole_length+cable_hole_distance, 0])
        CableHole();
        
        translate([-base_width/2 + cable_hole_edge_offset, cable_hole_length+cable_hole_distance, 0])
        CableHole();
        
        translate([base_width/2 - cable_hole_edge_offset, -cable_hole_length-cable_hole_distance, 0])
        CableHole();
        
        translate([-base_width/2 + cable_hole_edge_offset, -cable_hole_length-cable_hole_distance, 0])
        CableHole();
        
        rotate([180,0,-90])
        translate([-15,-3,0.8])
        linear_extrude(0.3) {
            text("CONAN II", size = 5);
        };
        
//        translate([base_width/2-1.5,base_height/2-15/2, 0])
//    rotate([0,0,90])
//        ScrewWallConnectors(true);
//        
//        translate([base_width/2-1.5,-base_height/2+15/2,0])
//    rotate([0,0,90])
//        ScrewWallConnectors(true);
//        
//        rotate([0,0,180]) {
//            translate([base_width/2-1.5,base_height/2-15/2, 0])
//        rotate([0,0,90])
//            ScrewWallConnectors(true, [0]);
//            
//            translate([base_width/2-1.5,-base_height/2+15/2,0])
//        rotate([0,0,90])
//            ScrewWallConnectors(true, [2,3]);
//        }
    }
    
    if(!for_export) {
        color("green")
        rotate([0,0,90])
        translate([0,0,1+9/2])
        BatteryPlaceholder();
    }
    
    translate([base_width/2-3,base_height/2-47,1])
    ScrewCylinder(stand_height);
    
    translate([-base_width/2+3,base_height/2-51,1])
    ScrewCylinder(stand_height);
    
    translate([-base_width/2+3,base_height/2-11,1])
    ScrewCylinder(stand_height);
    
    color("orange")
    translate([base_width/2-8,base_height/2-8,1])
    ScrewCylinder(stand_height);
    
    
    if(!for_export) {
            translate([0,0,base_thickness+stand_height])
        #PCBSimplification();
    
        translate([20.3,-base_height/2+7.5,-12/2 - screw_wall_offset - 1])
        MotorAndWheel();
        
        translate([-20.3,-base_height/2+7.5,-12/2 - screw_wall_offset - 1])
        rotate([0,0,180])
        MotorAndWheel();
        
        translate([20.3,base_height/2-7.5,-12/2 - screw_wall_offset - 1])
        MotorAndWheel();
        
        translate([-20.3,base_height/2-7.5,-12/2 - screw_wall_offset - 1])
        rotate([0,0,180])
        MotorAndWheel();
        
        translate([base_width/2-1.5,base_height/2-15/2,-7 - screw_wall_offset])
        rotate([0,0,90])
        ScrewWall();
        
        translate([base_width/2-1.5,-base_height/2+15/2,-7 - screw_wall_offset])
        rotate([0,0,90])
        ScrewWall(true);
        
        rotate([0,0,180]) {
            translate([base_width/2-1.5,base_height/2-15/2,-7 - screw_wall_offset])
            rotate([0,0,90])
            ScrewWall(false, true);
            
            translate([base_width/2-1.5,-base_height/2+15/2,-7 - screw_wall_offset])
            rotate([0,0,90])
            ScrewWall(true, true);
        }
    }
    
//    color("orange")
//    translate([10,-10,-1])
//    rotate([-90,0,-45])
//    CableGuide();
//    
//    color("orange")
//    translate([10,10,-1])
//    rotate([-90,0,45])
//    CableGuide();
//    
//    mirror([1,0,0]) {
//        color("orange")
//        translate([10,-10,-1])
//        rotate([-90,0,-45])
//        CableGuide();
//        
//        color("orange")
//        translate([10,10,-1])
//        rotate([-90,0,45])
//        CableGuide();
//    }
    
    translate([0, base_height/2-1, base_thickness/2+5])
    BatteryWall(false);
    
    translate([0, -base_height/2+1, base_thickness/2+5])
    BatteryWall(true);
};

//$fn = 100;
//$fn=50;

if(!for_export) {
    translate([0,0,20.5])
    Base();
} else {
    translate([0,0,base_thickness/2])
    Base();
}

//translate([0,0,0]) {
//    ScrewWall();
//    translate([0,18.6/2+3/2,0])
//    rotate([0,0,-90])
//    MotorAndWheel();
//}

//ScrewWall();

//rotate([-90,0,0])
//ScrewWall();

//rotate([-90,0,0])
//ScrewWall(true);

//rotate([-90,0,0])
//ScrewWall(false, true);

//rotate([-90,0,0])
//ScrewWall(true, true);


//CableGuide();

//rotate([90,0,0])
//ScrewWall();

//rotate([90,0,0])
//ScrewWall();
//
//rotate([0,0,180]) {
//    rotate([90,0,0])
//    ScrewWall([0]);
//    
//    rotate([90,0,0])
//    ScrewWall([2,3]);
//}

//rotate([90,0,0])
//ScrewWall([0]);

//rotate([90,0,0])
//ScrewWall([2,3]);

//rotate([90,0,0])
//ScrewWall([0]);