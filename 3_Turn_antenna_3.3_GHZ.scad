$fn=80;

h=80;              // pipe height

turns = 3;         // number of coil turns
pitch = 20.9;       // turn spacing (actual vertical distance between centers)
start = 25;         // distance from bottom to first element

pipe_d = 28.9;      // pipe external diameter
thick = 5;          // pipe thickness

step_wid = 0.8;     // step width
step_hei = 0.6;     // step height (height of wire holder)
step_ext = 0.4;     // step protrusion
wire_width = 1.35;  // distance between steps

dir = 1;            // 1 for RHCP, -1 for LHCP

base_d = 192;       // base diameter
base_thi = 10;      // base thickness (10mm)
bump_height = 5;    // bump thickness around the edges (5mm) for protrusion (غطاء القنينة)
hole_d = 10;         // hole diameter in the base

step_angle = 3;     // angle step for wire holders

e=0.01;

module helix(){

    // base - circular with hole in center and bump around edges like a bottle cap
    difference() {
        // base circle (without the bump)
        cylinder(d=base_d, h=base_thi);  // القاعدة الأساسية
        
        // hole in the center of the base (moved slightly to be centered)
        translate([0,0,0])
        cylinder(d=hole_d, h=base_thi + 1);  // الحفرة في المنتصف
        
        // create the hollow in the middle (bottom side) but after the main pipe
        translate([0, 0, -base_thi - 1]) // وضع التفريغ أسفل القاعدة بعد الأنبوب
        cylinder(d=base_d - 10, h=base_thi + 2);  // التفريغ في الوسط بعد الأنبوب الرئيسي

        // bump around the edges like a bottle cap (protruding downwards with a curve) after the pipe starts
        translate([0, 0, -bump_height - base_thi])  // تحريك البروز للأسفل بعد بداية الأنبوب
        cylinder(d=base_d - 10, h=bump_height );  // البروز في الحواف بأسلوب غطاء القنينة
    }

    // main pipe (now starts after the base thickness of 10mm)
    difference() {
        translate([0, 0, base_thi])  // تحريك الأنبوب ليبدأ بعد 10 ملم من الأسفل
        cylinder(d=pipe_d,h=h);  // الأنبوب الرئيسي
        translate([0,0,-e])
            cylinder(d=pipe_d-2*thick,h=h+2*e);  // التخلص من الجزء الداخلي للأنبوب
    }

    // wire holders
    for(t = [0:1]) {
        ang = dir==1?22.5:-67.5;
        color("red")
        for( i = [0:step_angle:turns*360] ) { 
            rotate([0,0,dir*i+ang])
            translate([pipe_d/2,0,(pitch*i/360) + start + wire_width*t - step_hei/2])
            rotate([0,90,0])
            cube([step_hei,step_wid,step_ext*2], center=true);   
        }
    }

    // bottom - wire ending
    translate([9.5,0,base_thi])
    difference() {
        cube([4,5,3], center=true);
        translate([-1,0,0])
        rotate([90,0,0])
        cylinder(d=1.5, h=10, center=true);
    }
}

helix();
