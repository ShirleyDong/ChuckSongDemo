//Tianxia Dong 117220530
SndBuf mySound => Pan2 pan => dac;
//load file
me.dir()+"/sound/Intro_Wind-Mark.wav" => mySound.read;
 
 while(true){
// random gain, rate (pitch), and pan each time
Math.random2f(0.3,0.8) => mySound.gain; 
Math.random2f(-0.5,0.5) => pan.pan;     
Math.random2f(0.2,0.8) => mySound.rate; 
//play it from the start time        
0 => mySound.pos;
12 :: second => now;
}