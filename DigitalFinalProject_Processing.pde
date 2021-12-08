//Processing part of the Musical Etch-A-Sketch:

import processing.serial.*;     // import the Processing serial library
Serial myPort;                  // The serial port
PImage bg;                     
float BrightnessRed;
float BrightnessGreen;
float BrightnessBlue;
float val;
float h = 0;
float x = 0;
float prvH;
float prvX;
float colorRain;
float currentX = 384;        
float currentY = 316;



void setup() {
  String portName = Serial.list()[3];              //setting the port the teensy is in
  myPort = new Serial(this, portName, 9600);  
  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
  
  size(768, 633);                                  //setting the screen size - same size as image
  bg = loadImage("EtchASketch.png");               //import an image and set it as variable bg
  background(bg);                                  //use image for background
}

void draw() {
  //if the rainbow line button is pressed, change the colorMode so the rainbow can fade through all the colors
  //used if statements so when it gets to the end of the color fade (red) it will fade backwards instead of jumping back to white
  if (colorRain > 0){
    strokeWeight(3);
    colorMode(HSB, 400);
    stroke(h, x, 400);
    if(h == 0 || x == 0){
      prvH = h;
      prvX = x;
      h += 1;
      x += 1;
    }
    else if (prvH < h){
      prvH = h;
      prvX = x;
      h = h + 1;
      x = x + 1;
      
    }
    if (h == 399 || x == 399){
      prvH = 399;
      prvX = 399;
      h = h-1;
      x = x-1;
     } 
     else if (prvH > h){
     h = h -1;
     x = x - 1;
    }
  }
  //if the rainbow mode button isn't pressed, use the sent RGB values to set the color of the line
   else{
     colorMode(RGB, 255, 255, 255);
     stroke(BrightnessRed,BrightnessGreen,BrightnessBlue);
     strokeWeight(3);  
   }
  
   
//for all the movement directions, a buffer is created so it wont draw outside of the screen section on the image being used as the background - line cant move behond that pixel number
  
  //move up if val = 0
    if (val == 1){
      if (currentY <= 102){
        currentY = 102;
      }
      else{
      line(currentX, currentY, currentX,currentY-2);
      currentY = currentY-2;
      }
    }
    
    //move down if val = 2
    if (val == 2){
      if (currentY >= 508){
        currentY = 508;
      }
      else{
      line(currentX,currentY,currentX,currentY+2);
      currentY = currentY+2;
      }
    }
    
    //move left if val = 3
    if (val == 3){
      if (currentX <= 104){
        currentX = 104;
      }
      else{
        line(currentX,currentY,currentX-2, currentY);
        currentX = currentX-2;
      }
    }
    
    //move right if val = 4
    if(val == 4){
      if (currentX >= 662){
        currentX = 662;
      }
      else{
      line(currentX, currentY, currentX+2, currentY);
      currentX = currentX+2;
      }
    }
    //reset the drawing if the reset button is pressed
    if(val == 5){
      currentX = 384;        
      currentY = 316;
      background(bg);
      
    }
  
}

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  //if recieved any bytes other than the linefeed:
    myString = trim(myString);
    // split the string at the commas
    // then convert the sections into integers:
    int sensors[] = int(split(myString, ','));
    println(myString);
    // print out the values recieved from the serial monitor:
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t"); 
    }
    // add a linefeed after all the sensor values are printed:
        println();
    if (sensors.length > 1) {
      BrightnessRed = sensors[0];
      BrightnessGreen = sensors [1];
      BrightnessBlue= sensors [2];
      
      //set val as the 4th value recieved in the serial monitor
      if (sensors.length > 3){
      val = sensors [3];
      }
      //set colorRain (rainbow settings) as the 5th value recieved in the serial monitor
      if(sensors.length > 4){
      colorRain = sensors[4];
      println(colorRain);
      }
    
    // send a byte to ask for more data:
    myPort.write("A");
  }
}
