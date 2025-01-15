module Torus(diameter, inner_diameter) {
    rotate_extrude(convexity = 10)
    translate([diameter, 0, 0])
    circle(r = inner_diameter / 2);
};

module OldWheel(diameter=30, inner_diameter=25, thickness=5, hole=1.6, wheel_thickness=4, groove_height=2) {
    union() {
        difference() {
            cylinder(thickness, diameter/2, diameter/2, center=true);
            cylinder(thickness+2, inner_diameter/2, inner_diameter/2, center=true);
        }
        
        translate([0,0,-thickness/2+1])
        WheelSupports(4, 2, inner_diameter/2);
        ShaftConn(hole);
    }
};

module Wheel(diameter=30, inner_diameter=25, thickness=5, hole=1.6, wheel_thickness=4, groove_height=2) {
//    difference() {
//        union() {
//            difference() {
//                cylinder(thickness, diameter/2, diameter/2, center=true);
//                cylinder(thickness+2, inner_diameter/2, inner_diameter/2, center=true);
//                Torus(diameter/2, wheel_thickness);
//            }
//            WheelSupports(4, 2, 12);
//            ShaftConn();
//        }
//        Torus(diameter/2, wheel_thickness);
//    }
    difference() {
        union() {
            difference() {
                cylinder(thickness, (diameter + groove_height)/2, (diameter + groove_height)/2, center=true);
                cylinder(thickness+2, inner_diameter/2, inner_diameter/2, center=true);
            }
            
            translate([0,0,-thickness/2+1])
            WheelSupports(4, 2, inner_diameter/2);
            ShaftConn(hole);
        }
        echo(diameter, groove_height, wheel_thickness, (diameter + wheel_thickness));
        Torus((diameter + wheel_thickness)/2, wheel_thickness);
    }
    
//    union() {
//        difference() {
//            cylinder(thickness, diameter/2, diameter/2, center=true);
//            cylinder(thickness+2, inner_diameter/2, inner_diameter/2, center=true);
//        }
//        
//        translate([0,0,-thickness/2+1])
//        WheelSupports(4, 2, inner_diameter/2);
//        ShaftConn(hole);
//    }
};

module ShaftConn(hole=1.5, diameter=6, thickness=5, extraction1=1.5, extraction1_diameter1=4, extraction1_diameter2=6,
    extraction2=2.5,
    extraction2_diameter=4,
    inner_stop=4.2
    ) {
    difference(){
        union() {
            difference() {
                union() {
                    cylinder(thickness, diameter/2, diameter/2, center=true);
                    translate([0,0,thickness/2+extraction1/2])
                    cylinder(extraction1, extraction1_diameter2/2, extraction1_diameter1/2, center=true);
                    
                    translate([0,0,thickness/2+extraction1+extraction2/2])
                    cylinder(extraction2, extraction2_diameter/2, extraction2_diameter/2, center=true);
                }
                cylinder(thickness+30, hole/2, hole/2, center=true);
            }
            translate([0,0,-thickness/2+inner_stop/2])
            cylinder(inner_stop, diameter/2, diameter/2, center=true);
        }
        
        translate([0,-1.5,0])
        cube([0.4, 3, 100], center=true);
        
        cylinder(100, 0.4, 0.4, center=true);
    }
};

module WheelSupport(width, height, length) {
    rotate([90,0,0])
    cube([width, height, length], center=true);
};

module WheelSupports(width, height, length, offset=5/2-1.5, count=3) {
    union(){
        for(i = [0 : count]) {
            rotate([0,0,i * 360/count])
            translate([0,length/2 + offset,0])
            WheelSupport(width, height, length - offset);
        }
    }
};


//$fn=100;

//Wheel(25, 23);
//Torus((25+4)/2, 4);

export_wheel_diameter = 25;
export_wheel_thickness=2;
base_width=65.2;
base_height=65.2;
export_dist = 2.5;
    
//translate([-export_wheel_diameter/2-export_dist/2,+25/2+export_dist/2,2.5])
//for(i = [0 : 1]) {
//    translate([(export_wheel_diameter + export_dist) * i, 0, 0])
//    Wheel(export_wheel_diameter, export_wheel_diameter-export_wheel_thickness);
//}
//
//translate([-export_wheel_diameter/2-export_dist/2,-25/2-export_dist/2,2.5])
//for(i = [0 : 1]) {
//    translate([(export_wheel_diameter + export_dist) * i, 0, 0])
//    Wheel(export_wheel_diameter, export_wheel_diameter-export_wheel_thickness);
//}

//translate([0,0,-10])
//Wheel(export_wheel_diameter, export_wheel_diameter-export_wheel_thickness);

//OldWheel(export_wheel_diameter, export_wheel_diameter-export_wheel_thickness);

//color("red")
//cube([0.4, 3, 100], center=true);
