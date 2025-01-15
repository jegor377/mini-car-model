module MotorShaft(mlen) {
    union() {
            color("gray")
            intersection() {
                cylinder(mlen, 7.5, 7.5);
                
                translate([-6, -7.5, 0])
                cube([12, 15, mlen]);
            }
            
            color("black")
            translate([0, 0, -0.7])
            cylinder(0.7, 2.5, 2.5);
        }
};

module MotorStick(mlen, klen) {
    color("black")
    translate([0, 0, mlen])
    cylinder(klen, 4.7/2, 4.7/2);
    
    color("gray")
    translate([0, 0, mlen + klen])
    cylinder(7-1.5, 1.5/2, 1.5/2);
};

module MotorConnector() {
    intersection() {
        difference() {
            translate([-1.5/2,-0.3/2,0])
            cube([1.5,0.3,2.15]);
            
            translate([0,0.5/2,1.5])
            rotate([90,90,0])
            cylinder(0.5,0.4,0.4);
        }
        hull() {
            translate([-1.5/2,-0.3/2,0])
            cube([1.5,0.3,1]);
            
            translate([0,0.5/2,11*2.15/16])
            rotate([90, 0, 0])
            cylinder(0.5, 1.5/2, 1.5/2);
        }
    }
};

module TwoMotorConnectors(dist, angle, dist2) {
    rotate([0,0,-angle]) {
        translate([dist2,-dist/2,0])
        rotate([0,180,0])
        MotorConnector();
        
        translate([-dist2,dist/2,0])
        rotate([0,180,0])
        MotorConnector();
    }
};

module MountingHole() {
    color("red")
    translate([0, 0, -1])
    cylinder(2, 1, 1);
};

module MotorMountingHoles(dist, angle) {
    rotate([0, 0, angle]) {
        translate([0, -dist/2, 0])
        MountingHole();
        
        translate([0, dist/2, 0])
        MountingHole();
    }
};

module Motor(mlen=18.6, klen=1.5) {
    
    translate([0, 0, -mlen/2])
    difference() {
        union() {
            MotorShaft(mlen);
            
            MotorStick(mlen, klen);
            
            color("gold")
            TwoMotorConnectors(8, 23, 1.3);
        }
        
        translate([0,0,mlen])
        MotorMountingHoles(10, 30);
    }
};

//rotate([90, 90, 0])
//Motor();
