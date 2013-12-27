// http://www.openprocessing.org/visuals/?visualID=6268
// wrestled into VJ compatible MIDI form by Jay Silence

import themidibus.*;
 
// MIDI bus for parameter input via Akai LPD8
MidiBus myBus;

void initLPD8()
{
   if (debug) MidiBus.list(); // List all available Midi devices on STDOUT. 
  // Create a new MidiBus with Akai input device and no output device.
  myBus = new MidiBus(this, "LPD8", -1);
}

// Handle keyboard input
void keyPressed()
{
  switch(key){
    case 'd':
      debug = !debug;
      break;
    case 's':
      saveFrame("sreenCaptures/img-######.png");
      break;
  }
}
 
// MIDI Event handling
void noteOn(int channel, int pad, int velocity) {
  // Receive a noteOn
  if(debug) {
    print("Note On - ");
    print("Channel "+channel);
    print(" - Pad "+pad);
    println(" - Value: "+velocity);
  }
  switch(pad){
    case 0:
      break;   
    default:
      break;   
  }
}
 
 
// Right now we are doing nothing on pad release events
void noteOff(int channel, int pad, int velocity) {
    // Receive a noteOff
  if(debug) {
    print("Note Off - ");
    print(" Channel "+channel);
    print(" - Pad "+pad);
    println(" - Value "+velocity);
  }
}
 
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if(debug) {
    print("Controller Change - ");
    print("Channel "+channel);
    print(" - Number "+number);
    println(" - Value "+value);
  }
   
  switch(number){
    case 1:  // = K1
      threshholdVal = value*15/127.f;
      break;
    case 2: // = K2
      zScaling = value*15/127.f;
      break;  
    case 3: // = K3
      break;  
    case 4: // = K4
      break;  
    case 5: // = K5
      break;  
    default:
      break;   
  } 
}

