import interfascia.*;  // Import button handling library

PrintWriter output;    // Create writer object for output file
PFont font;            // Create font object
PGraphics pg;          // Create graphics object buffer
PImage logoCVAC;       // Create image object for CVAC image
PImage logoPaw;        // Create image object for tiger paw image
PImage imgRecording;   // Create image object for recording image
color bengalStripe, innovationGrey, clemsonOrange, tillmanBrick, regaliaPurple, calhounGreen; // Create color objects
boolean backgroundColor = false;
String dataStoreLocation;
String fileName = "";
String dataToSave = "";
boolean saveLocSet = false;
int buttonHeight = 40;
int buttonWidth = 100;
GUIController c;
IFButton b1, b2, b3, b4, b5, b6, b7, b8;
IFButton calButton, exitButton;
IFLabel l;

//void settings() {
//    fullScreen(); // Force Fullscreen
//}

void setup() {
  // Setup window
  surface.setTitle("CU-ICAR Sensor Glove Data Labeling"); // Set title bar
  surface.setSize(420, 400);
  frameRate(20);
  background(color(#86898C));
  pg = createGraphics(width, height);
  prepareExitHandler();
  
  // Load images
  logoCVAC = loadImage("images/CVAC_Logo.png");     // CVAC logo for title
  logoPaw = loadImage("images/TigerPaw.png");       // CU Tiger paw
  imgRecording = loadImage("images/Recording.png"); // Recording message
  font = createFont("Arial",30,true);        // Create font object for all text
  
  // Set color objects 
  bengalStripe = color(#000000); // Set color of rectangle
  innovationGrey = color(#86898C); // Innovation Grey // Set highlighted color of rectangle
  clemsonOrange = color(#F66733); // Clemson Orange // Set color of circle
  tillmanBrick = color(#A25016); // Tillman Brick // Set highlighted color of circle
  regaliaPurple = color(#522D80); //Regalia Purple
  calhounGreen = color(#B5C327); //Calhoun Fields Green
  
  // User set save folder 
  selectFolder("Select a folder to save files to:", "folderSelected");
  fileName = str(year())+"-"+str(month())+"-"+str(day())+"_"+str(hour())+"-"+str(minute())+"-"+str(second())+"_dataLabels.txt";
  println(fileName);
  
  c = new GUIController (this);
  
  // Create button objects and labels
  b1 = new IFButton ("Heaterbox_1", 40, 40, buttonWidth, buttonHeight);
  b2 = new IFButton ("Heaterbox_2", 160, 40, buttonWidth, buttonHeight);
  b3 = new IFButton ("I-combi", 280, 40, buttonWidth, buttonHeight);
  b4 = new IFButton ("Screwgun", 40, 120, buttonWidth, buttonHeight);
  b5 = new IFButton ("HUD_install", 160, 120, buttonWidth, buttonHeight);
  b6 = new IFButton ("HUD_connection", 280, 120, buttonWidth, buttonHeight);
  b7 = new IFButton ("Handscan", 40, 200, buttonWidth, buttonHeight);
  b8 = new IFButton ("MISC", 160, 200, buttonWidth, buttonHeight);
  calButton = new IFButton("Calibrate", 40, 280, buttonWidth, buttonHeight);
  exitButton = new IFButton ("EXIT", width-buttonWidth, height-buttonHeight, buttonWidth, buttonHeight);
  
  // Create button action listeners
  b1.addActionListener(this);
  b2.addActionListener(this);
  b3.addActionListener(this);
  b4.addActionListener(this);
  b5.addActionListener(this);
  b6.addActionListener(this);
  b7.addActionListener(this);
  b8.addActionListener(this);
  calButton.addActionListener(this);
  exitButton.addActionListener(this);
    
  // Add buttons to draw
  c.add (b1);
  c.add (b2);
  c.add (b3);
  c.add (b4);
  c.add (b5);
  c.add (b6);
  c.add (b7);
  c.add (b8);
  c.add (calButton);
  c.add (exitButton);
}

void draw() {
  if (saveLocSet == false) { // Check if save location set and inform user
    pg.beginDraw();
    pg.fill(0);
    pg.rect(0, 0, width, height);
    pg.fill(255);
    pg.text("Save location not set...Please restart app", 20, height-20);
    pg.endDraw();
    image(pg,0,0);
  } else {
    background(g.backgroundColor);
  }
  // Draw images
  //image(logoCVAC, 10, 10, logoCVAC.width*1/3, logoCVAC.height*1/3);
  //image(logoPaw, (width-(logoPaw.width/4.5)), (height-30-(logoPaw.height/4)), logoPaw.width/6, logoPaw.height/6);
}

void colorCheck() {
  if (g.backgroundColor == clemsonOrange){
    background(regaliaPurple);
  } else {
    background(clemsonOrange);
  }
}

void actionPerformed (GUIEvent e) {
  if (saveLocSet == true){
    if (e.getSource() == b1) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b1.getLabel();
      output.println(dataToSave); // Add data to output array
      colorCheck();
    } else if (e.getSource() == b2) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b2.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == b3) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b3.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == b4) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b4.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == b5) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b5.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == b6) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b6.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == b7) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b7.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == b8) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+b8.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == calButton) {
      dataToSave = year()+":"+month()+":"+day()+","+hour()+":"+minute()+":"+second()+","+calButton.getLabel();
      output.println(dataToSave);
      colorCheck();
    } else if (e.getSource() == exitButton) {
      println("Exit button pressed, exiting...");
      output.flush(); // Writes the data to the file
      output.close(); // Finishes the file
      exit();
    }
    output.flush(); // Writes the data to the file
  }
}

void folderSelected(File saveLocation) { // Check for and set folder location by user input
  if (saveLocation == null) {
    println("Save location not set...");
    saveLocSet = false;
  } else {
    saveLocSet = true;
    dataStoreLocation = saveLocation.getAbsolutePath()+'/';
    dataStoreLocation = dataStoreLocation.replace('\\', '/');
    println("Save location set to: " + dataStoreLocation);
    // Create a new file in the sketch directory
    output = createWriter(dataStoreLocation + fileName);
  }
}

void keyPressed() {
  if (key==ESC) {
    key=0;
    println("Esc key pressed, exiting...");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    exit();
  }
}

private void prepareExitHandler() { // Handle closing file on shutdown button pressed
Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
public void run () {
println("SHUTDOWN HOOK"); // Shutdown code goes below this
if(saveLocSet == true){
  println("shutdown button pressed, exiting...");
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}
}
}));
}
