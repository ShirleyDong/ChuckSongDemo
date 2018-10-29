//Tianxia Dong 117220530
//TriOsc s => StifKarp instr => dac;
//TriOsc s => Mandolin instr => dac;
//TriOsc s => PercFlut instr => dac;
//TriOsc s => Bowed instr => dac;

//ugens for my music
SndBuf mySound => Pan2 pan => dac;   
TriOsc s;  
//event for  frequency manipulation                               
Event evnt;



//class for variables 
public class Var
{
    //define the note variables 
    0.5::second =>dur q;
    0.25::second=>dur e;
    1.0::second =>dur h;
    [q,e,q,q,q,q,h, q,q,h,q,q,h, q,e,q,q,q,q,h, h,h,q,h] @=>dur myDurs[];
    
    //generate melody 
    [67,69,67,65,64,65,67, 62,64,65,64,65,67, 67,69,67,65,64,65,67, 62,67,64,60] @=> int scale[];
    
    
    
    function void freqM(Event anEvent){
        // modulator to carrier
        TriOsc m => s => dac;
        // carrier frequency
        220 => s.freq;
        // modulator frequency
        220 => m.freq;
        anEvent => now;
        }
}

//play melody in first instrument
fun void play1(){
        s => Mandolin instr => dac;
        // (2) Note on/off gains
        0.8 => instr.gain;
        0.7 => float onGain;    
        0.0 => float offGain;
        
        //object for Var class
        Var v;
              
        // loop for length of array 
        for (0 => int i; i < v.scale.cap(); i++)
        {
            <<< i, v.scale[i] >>>;// Prints index and array note
            
            // set frequency and gain to turn on our note
            v.scale[i] => int freq;
            
            //midi to freq
            Std.mtof(freq) => instr.freq;
            
            
            
            //onGain => s.gain;
            1 =>instr.noteOn;   
            0.7*v.myDurs[i] => now;              // (7) Duration for note on
            
            // turn off our note to separate from the next
            //offGain => s.gain;
            0 =>instr.noteOff;                // (8) Note off
            0.3*v.myDurs[i] => now;
            
            // random gain, rate (pitch), and pan each time
            // Random pan position
            Math.random2f(-0.5,0.5) => pan.pan;  
            // Random rate (speed and pitch)
            //Math.random2f(0.2,0.8) => mySound.rate;
            
        }
    }
    
    
//play melody in second instrument   
fun void play2(){
        s => StifKarp instr => dac;
        // (2) Note on/off gains
        0.8 => instr.gain;
        0.7 => float onGain;    
        0.0 => float offGain;
        
        Var v;     
        // loop for length of array 
        for (0 => int i; i < v.scale.cap(); i++)
        {
            <<< i, v.scale[i] >>>;// Prints index and array note
            
            // set frequency and gain to turn on our note
            v.scale[i] => int freq;
            
            //midi to freq
            Std.mtof(freq) => instr.freq;
            
            
            
            //onGain => s.gain;
            1 =>instr.noteOn;   
            0.7*v.myDurs[i] => now;              // (7) Duration for note on
            
            // turn off our note to separate from the next
            //offGain => s.gain;
            0 =>instr.noteOff;                // (8) Note off
            0.3*v.myDurs[i] => now;
            
            // random gain, rate (pitch), and pan each time
            Math.random2f(-0.5,0.5) => pan.pan;     // Random pan position
            
        }
    }
    
    
//functions for playing the audio
fun void playSound(){
    //array for sound file
   SndBuf snare[3];
   //spatial effect
   snare[0] => dac.left;
   snare[1] => dac;
   snare[2] => dac.right;
   
   //get the directory of my file
   me.dir()+"/sound/snare_01.wav" => snare[0].read;
   me.dir()+"/sound/snare_02.wav" => snare[1].read;
   me.dir()+"/sound/snare_03.wav" => snare[2].read;
   while (true)
       {
           Var v;      
           // loop for length of array 
           for (0 => int i; i < v.scale.cap(); i++){
           Math.random2(0,snare.cap()-1) => int which;
           0 => snare[which].pos;
           v.myDurs[i] => now;
       }
    }
}


//subclass and function overloading
class log1
{
    fun void print( int a )
    { <<<"Playing music1.">>>; }
    
    fun void print( int a, int b )
    { <<<"Playing the frequency modulation music.">>>; }
}

class log2 extends log1{
    fun void print( int a )
    { 
        <<<"Playing music2.">>>; 
    }
}
 
//playing the drum
spork ~ playSound(); 

//event
Var ve;
//spork for frequency manipulation
spork ~ ve.freqM(evnt);
evnt.signal();


//play background music
Machine.add(me.dir()+"bg.ck");

//switch the instruments
1 => int changeIns;
while( true )
{
    //objects for print class 
    log1 p1;
    log2 p2;
    //use conditional statement to control instrument
    if(changeIns ==1){
        p2.print(1);
         play2();
         0 => changeIns;
     }else{
         p1.print(1);
         play1();
         1 => changeIns;
         }
    p2.print(1,1);    
    //playSound();
    1 :: second => now;   
}
