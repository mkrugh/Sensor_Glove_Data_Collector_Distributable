/*  
    Data ingestion over serial com and save to user-defined directory for CU-ICAR/CVAC 
    sensor glove prototype.
    Code copyright 2017 Matthew Krugh (mkrugh@g.clemson.edu).
    No license for use, development, or other purpose is provided/allowed
    without express written permission of Matthew Krugh (mkrugh@g.clemson.edu).
    Code is provided as-is and use is at users own risk with no express or implied guarantees.
    
    Requires Java 8 Standard Edition Runtime Environment to be installed or packaged with distributable
*/

import processing.serial.*; // required for serial communication

PFont font;              // Create font object
Serial myPort;           // Create object from Serial class
float xPos = 0;          // Horizontal position of the running logo
float yPos = 0;          // Vertical position of the running logo
int count = 0;           // Counter for serial port
String input;            // Data received from the serial port
int saveLength = 100;     // Max number of samples to read before saving to disk
String dataToSave[] = {};// Aggregate data to save to disk 
String stop = "STOP";    // Text for stop button
String rec = "RECORD";   // Text for record button
String fileName = "";    // Filename to save data
String checkFileName;    // Filename of previous data collection run
String dataStoreLocation;
boolean buttonPressed = false;
boolean saveLocSet = false;

PImage logoCVAC;       // Create image object for CVAC image
PImage logoPaw;        // Create image object for tiger paw image
PImage imgRecording;   // Create image object for recording image
int offsetHoriz = 90;  // Offset for buttons and text
int rectX, rectY;      // Position of square button
int circleX, circleY;  // Position of circle button
int rectSize = 90;     // Size of rect
int circleSize = 93;   // Diameter of circle

color rectColor, circleColor; // Base colors for shapes 
color rectHighlight, circleHighlight; // Highlighted colors for shapes
color regaliaPurple, calhounGreen; // Background colors
color currentColor;
boolean rectOver = false;
boolean circleOver = false;

void setup()
{
  // Setup window
  surface.setTitle("CU-ICAR Sensor Glove Data Collection"); // Set title bar
  size(800, 600); // Set window size
  background(#86898C); // Innovation Grey // Set background color of boot screen
  printArray(Serial.list()); // Print list of available serial devices
  
  // Open serial port to sensor glove, on Windows machines, this generally opens COM1.
  String portName = Serial.list()[0]; // change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 57600); // Open com port to sensor glove
  myPort.bufferUntil('\n'); // wait until \n to start call to serialEvent
  
  // Load images
  logoCVAC = loadImage("images/CVAC_Logo.png");     // CVAC logo for title
  logoPaw = loadImage("images/TigerPaw.png");       // CU Tiger paw
  imgRecording = loadImage("images/Recording.png"); // Recording message
  font = createFont("Arial",30,true);        // Create font object for all text
  
  // User set save folder 
  selectFolder("Select a folder to save files to:", "folderSelected");
  
  delay(3000); // delay to let com port open and setup
  
  // Shape color setup
  rectColor = color(#000000); // Set color of rectangle
  rectHighlight = color(#86898C); // Innovation Grey // Set highlighted color of rectangle
  circleColor = color(#F66733); // Clemson Orange // Set color of circle
  circleHighlight = color(#A25016); // Tillman Brick // Set highlighted color of circle
  regaliaPurple = color(#522D80); //Regalia Purple
  calhounGreen = color(#B5C327); //Calhoun Fields Green
  currentColor = regaliaPurple;
  
  // Shape position setup
  circleX = width/2+circleSize/2+offsetHoriz; // set circle x-origin
  circleY = height/2;                         // set circle y-origin
  rectX = width/2-rectSize-offsetHoriz;       // set rectangle x-origin
  rectY = height/2-rectSize/2;                // set rectangle y-origin
  ellipseMode(CENTER);
}

void serialEvent (Serial myPort) {
  while ((myPort.available() > 0) && buttonPressed) {  
    input = myPort.readString();  // read serial port
    print(count + ": " + input);
    if (count >= saveLength) { // Save to file after saveLength number of samples read
      //save data to file
      count = 0;
      dataToSave = trim(dataToSave);
      saveStrings(dataStoreLocation+fileName, dataToSave);
    } else {
      dataToSave = append(dataToSave, input);
      count+=1;
    }
    //if (input != "empty"){
    //  dataToSave = append(dataToSave, input);
    //  print(count + ": " + input);
    //  count+=1;
    //  input="empty";
    //}
  }
  //Check for availability of com and if it disconnects, notify user

  if(buttonPressed == false) {
    myPort.clear();
    count=0;
    dataToSave = new String[0];
  }
}

void draw()
{
  update(mouseX, mouseY);
  textFont(font);
  textAlign(CENTER); // MOVE TO SETUP?
  background(currentColor);
  
  // Draw rectangle
  if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(0);
  rect(rectX, rectY, rectSize, rectSize);
  // Draw stop text
  text(stop, width/2-rectSize/2-offsetHoriz, rectY-20);  
  
  // Draw circle
  if (circleOver) {
    fill(circleHighlight);
  } else {
    fill(circleColor);
  }
  stroke(0);
  ellipse(circleX, circleY, circleSize, circleSize);
  // Draw record text
  text(rec, circleX, rectY-20);
  
  // Show recording image if button pressed
  if (buttonPressed){
    image(imgRecording, width/2-imgRecording.width/6+10, height*2/3, imgRecording.width/3, imgRecording.height/3);
  }
  
  //Show logo images on page
  image(logoCVAC, 10, 10, logoCVAC.width*2/3, logoCVAC.height*2/3);
  image(logoPaw, (width-10-(logoPaw.width/3)), (height-10-(logoPaw.height/3)), logoPaw.width/3, logoPaw.height/3);
  
  // File save location not set properly message
  if (saveLocSet == false) { 
    fill(0);
    rect(0, 0, width, height);
    fill(255);
    text("Save location not set...Please restart app", width/2, height/2);
  }
}

void update(int x, int y) {
  if ( overCircle(circleX, circleY, circleSize) ) {
    circleOver = true;
    rectOver = false;
  } else if ( overRect(rectX, rectY, rectSize, rectSize) ) {
    rectOver = true;
    circleOver = false;
  } else {
    circleOver = rectOver = false;
  }
}

void mousePressed() {
  if (circleOver && saveLocSet) {
    // Set background color to green while recording
    currentColor = calhounGreen;
    checkFileName = fileName;
    fileName = str(year())+"-"+str(month())+"-"+str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(second())+".txt"; // Create new filename everytime record button is pressed
    // Check for existing filenames 
    //if (fileName.equals(checkFileName) == true){
    //  println("same file name: "+fileName);
    //  delay(1100);
    //  fileName = str(year())+":"+str(month())+":"+str(day())+"."+str(hour())+":"+str(minute())+":"+str(second())+".txt"; // Create new filename everytime record button is pressed
    //  buttonPressed=true;
    //} else {
    //  buttonPressed=true;
    //}
    //println("\n"+checkFileName);
    println("\n"+fileName+"\n");
    buttonPressed=true;
  }
  if (rectOver && saveLocSet) {
    buttonPressed=false;
    // Set background color to purple while not recording
    currentColor = regaliaPurple;
  }
}

void folderSelected(File saveLocation) {
  if (saveLocation == null) {
    println("Save location not set...");
    saveLocSet = false;
  } else {
    saveLocSet = true;
    dataStoreLocation = saveLocation.getAbsolutePath()+'/';
    dataStoreLocation = dataStoreLocation.replace('\\', '/');
    println("Save location set to: " + dataStoreLocation);
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
