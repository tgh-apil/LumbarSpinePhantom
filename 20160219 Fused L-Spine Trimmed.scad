$fn = 60;

// NOTE: To compile the design you will need to modify the path for the file FusedLSpine-Dec0.75-Sm15-trimmed.stl in the import command in module Spine() to your spine model. 


// Inner Length, BackWidth, FrontWidth and Height in mm
IL = 181; //181 full 5 level model; 80 - 100 for 3 level model
IBW = 65;
IFW = 160;
IH = 68;

rr = 8; //radius for rounded corners on the box

// Wall and Floor Thickness
WT = 3.5;
FT = 15;

/////////////////////// Calculated values
// Outer dimensions
OL = IL+WT+FT;
OBW = IBW+5*WT; // 2*WT would result in uniform wall thickness (along x-axis. 6*WT is used to increase the wall thickness gradually towards the base for strength. This is specially important to maintain shape stability when the hot get is poured in.
OFW = IFW+2*WT;
OH = IH+WT;


main();

// Import and place the STL in standard position
// ***************************************************************************
// MODIFY THE PATH FOR THE FILE FusedLSpine-Dec0.75-Sm15-trimmed.stl in the import command in module Spine().
// ***************************************************************************
// ***************************************************************************

module Spine(){
    intersection(){
        translate ([-5,-325,37]) // -5 -318 37 for full
            rotate ([-98,0,180])
                import("/home/azad/Dropbox/Toronto Werx/Spine/20160115 MECANIX Fused LSpine Seg- Azad/FusedLSpine-Dec0.75-Sm15-trimmed.stl", convexity=3);
    
        // lateral trimming of the spine
        Strimbox();
        }
}

module main(){
difference(){
   intersection(){
        union(){
            curvedCoffin();   
            Spine();
        }
    
        //trimming cube to remove parts of spine outside the box
        Ltrimbox();
    }
        
    // Hole for desk mount
    translate([0,OL-FT/2,-0.50])   
        rotate([0,0,90])
            cylinder (r=4.3,h=IH*2);
    
    // Hole for spinal canal
    translate([0,OL+10,14])
        rotate([90,0,0])
            cylinder (r=7,h=OL*2);

    }
}

// trimbox for whole model
module Ltrimbox(){
    Width = 600;
    difference(){
        translate ([- Width/2,0, 0])
                cube([Width,OL,600]);
    
        // Trimming bone extrusion 
        translate([2*OFW,rr,rr])
        rotate([-90,90,90])
            difference(){
                cube([2*rr,2*rr,4*OFW]);
                translate([0,0,-0.5])
                    cylinder(r=rr,h=5*OFW);
            }
        }
    }

// trimbox for Spine    
module Strimbox(){  
        Width = 50;
        translate ([-Width/2,0, 0])
            cube([Width,OL,600]);
}  


// Profile of the outer shell of the box
// TW = Width at the top
// BW = Width at the bottom
// Ht = Height
module curvedCoffinProfile(TW, BW, Ht){
    // straight wall length (if side not curved)
    SWL = sqrt(pow((TW-BW),2)/4 + pow(Ht-3,2));

    // radius of wall curve
    Rad = pow(SWL,2)/(TW-BW);
    
    difference(){
        square([Ht,TW]);
        translate ([0,-Rad+(TW-BW)/2,0])
            circle(Rad);
        translate ([0,TW+Rad-(TW-BW)/2,0])
            circle(Rad);
    }
}
    
module curvedCoffin(){  
        
        // diameter for minkowski rounding of the innner cavity
        mD = rr-WT;   
    
        translate ([-IFW/2-WT,0,0])
        rotate ([0,-90,-90])
        difference(){
            
            // Outer shell
            translate([rr,rr,rr])
            minkowski(){ // for rounding corners
                cube([OH-2*rr,OFW-2*rr,OL]); 
                sphere (rr);
            }
            
            // Inner cavity
            translate([WT+mD,WT+mD,WT+mD])
            minkowski(){ // for rounding corners
                linear_extrude(height=IL-2*mD)
                    curvedCoffinProfile(IFW-2*mD, IBW-2*mD, IH+0.5-mD/2);
                sphere (mD);
            }
        }
}
    
// rounded cornered box for trimming the Coffin box to round the outer corners
// W,L,H Width, Length and Height of the shape to be rounded
// r rounding radius
//module CoffinTrimbox(W,L,H,r){
//    rotate([90,0,90])
//    hull(){
//        translate([W-r,r,0]) cylinder (r=r, h=H);
//        translate([r,r,0]) cylinder (r=r, h=H);
//        translate([W-r,L-r,0]) cylinder (r=r, h=H);
//        translate([r,L-r,0]) cylinder (r=r, h=H);
//    }
//}
