$fn = 60;

//intersection(){
//    translate([-150,0,0])
//  cube([300,300,300]);
//  moldTop();  
    
//}

//moldbase();
moldBottom();

translate ([MoldW+5,0,0])
moldTop();
//rods();
//rod();
//BRodCap();
//rndCyl (20,40,5);

// Radius and Height of mold casing
MoldR = 15; // For round vertical mold
MoldL = 20; // For cubic horizonatal mold; Based on the metal clamp width 
MoldW = 26; // For cubic horizonatal mold; Based on the metal clamp width 
MoldH = 200; // For round vertical mold

// Dimensions of cylinder tube to be molded
CylH = 190; // outer height
CylOR = 6.5; // outer radius
CylIR = 4.37; // internal radius
BotThk = 3; // bottom Thickness

// For fully printed central rod
// connecting rod to connect the two halved of the central rod
ConRodRad = 2;
ConRodH = 40;

// Caps if using brass tube as central rod
BRodOR = 4.42; // Outer radius
BRodIR = 3.98; // Inner radius

module BRodCap () {
    union(){
        difference(){
            translate([0,0,2*BRodOR])
            sphere(BRodOR);
            cube(4*BRodOR,center=true);
        }
        rndCyl(BRodIR,2.6*BRodOR,1.5);
    }
}

// Creates a cylinder radius R, height H with corners rounded with radius rndR
module rndCyl (R, H, rndR){
    translate([0,0,rndR])
    minkowski(){
        cylinder(r=R-rndR,h=H-2*rndR);
        sphere(rndR); 
    }
}
        
module moldbase(){
    difference(){
    union(){
        //cylinder(r=MoldR,h=MoldH+10);
        cylinder(r=MoldR*2,h=25);
    }
    
    translate([0,0,-0.5])
        cylinder(r=CylIR,h=30); // Hole for inner shell rod to sit in (radius 1 mm smaller than the rod)
    
    }
}
    
module moldBottom(){
    difference(){
        union(){
            //cylinder(r=MoldR,h=MoldH+10);
            //cylinder(r=MoldR*2,h=MoldH+10,r2=MoldR);
            
            translate([0, MoldL/4,(CylH+30)/2])
            cube([MoldW,MoldL/2,CylH+30],center=true);
            translate([0,0,7.5 ])
            cube([MoldW,MoldL,15],center=true);
        }
        
        translate([0,0,35])
        union(){
            cylinder(r=CylOR,h=CylH); // The outer shell
            translate([0,0,-40])
            cylinder(r=BRodOR,h=CylH-1.0); // Hole for Brass Rod
        }
    }
}

module moldTop(){
    difference(){
        difference(){
            //cylinder(r=MoldR,h=MoldH+10);
            //cylinder(r=MoldR*2,h=MoldH+10,r2=MoldR);
            
            translate([0, MoldL/4,(CylH+30)/2])
            cube([MoldW,MoldL/2,CylH+30],center=true);
            translate([0,0,7.5 ])
            cube([MoldW+0.5,MoldL+0.5,17],center=true);
        }
        
        translate([0,0,35])
        union(){
            cylinder(r=CylOR,h=CylH); // The outer shell
            translate([0,0,-40])
            cylinder(r=BRodOR,h=CylH-1.0); // Hole for Brass Rod
        }
    }
}

module rod (){
    translate([0,0,10])
    difference(){
        union(){
            translate([0,0,CylH-CylIR-BotThk])
                sphere(r=CylIR);
            cylinder(r=CylIR,h=CylH-CylIR-BotThk); 
            translate([0,0,-10+CylIR-1.25])
            cylinder(r=CylIR-1.25,h=CylH-11.0);
            translate([0,0,-10+CylIR-1.25])
            sphere (r=CylIR-1.25);
        }
        
        translate([0,0,(MoldH-ConRodH)/2])
        cylinder(r=ConRodRad, h=ConRodH);
    }
}

module rods(){
    translate ([7,0,(CylH+10-BotThk)/2])
    rotate([180,0,0])
    intersection(){
      cube([300,300,CylH+10-BotThk],center=true);
      rod();  
    }
    
    translate ([-7,0,(CylH+10-BotThk)/2])
    rotate([180,0,0])
    intersection(){
      cube([300,300,CylH+10-BotThk],center=true);
      translate([0,0,CylH+10-BotThk])
        rotate([180,0,0])  
            rod();  
    }
}
