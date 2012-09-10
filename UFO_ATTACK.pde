import shapes3d.utils.*;
import shapes3d.animation.*;
import shapes3d.*;

import processing.opengl.*;

Terrain terrain;
Box skybox;
Cone[] droids;
Tube tube;
Ellipsoid obelisk;
Shape3D selected;
PFont font; 

PVector[] droidDirs;
int nbrDroids;
  PVector np;
    PVector cp; 
    int boss = 0;
    Boolean God = true;
   Boolean Start = false; 
   Boolean Countdown = false; 
   int NewGame = 1; 


TerrainCam cam;
int camHoversAt = 8;

float terrainSize = 1000;
float horizon = 400;

long time;
float camSpeed;
int count;

// List of image files for texture
String[] textures = new String[] {
  "grid01.png", "tartan.jpg", "rouge.jpg",
  "globe.jpg",  "sampler01.jpg"};

void setup(){
  size(800,720, OPENGL);
  cursor(CROSS);
  font = loadFont ( "Stencil-48.vlw");
  textFont(font, 48);
  terrain = new Terrain(this, 60, terrainSize, horizon);
  terrain.usePerlinNoiseMap(0, 40, 0.15f, 0.15f);
  terrain.setTexture("grass2.jpg", 4);
  terrain.tag = "Ground";
  terrain.tagNo = -1;
  terrain.drawMode(Shape3D.TEXTURE);
  
  skybox = new Box(this,1000,500,1000);
  skybox.setTexture("kobe.jpg", Box.FRONT);
  skybox.setTexture("front.jpg", Box.BACK);
  skybox.setTexture("left.jpg", Box.LEFT);
  skybox.setTexture("right.jpg", Box.RIGHT);
  skybox.setTexture("sky.jpg", Box.TOP);
  skybox.visible(false, Box.BOTTOM);
  skybox.drawMode(Shape3D.TEXTURE);
  skybox.tag = "Skybox";
  skybox.tagNo = -1;

  nbrDroids = 1;
  droids = new Cone[nbrDroids];
  droidDirs = new PVector[nbrDroids];
  for(int i = 0; i < nbrDroids; i++){
    droids[i] = new Cone(this,10);
    droids[i].setSize(25,25,10);
    droids[i].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 50));
    droids[i].tagNo = 100;
    droids[i].fill(color(random(128,255), random(128,255), random(128,255)));
    droids[i].drawMode(Shape3D.SOLID);
    droidDirs[i] = getRandomVelocity(random(20,30));
    terrain.addShape(droids[i]);
    
  }

  
  camSpeed = 0;
  cam = new TerrainCam(this);
  cam.adjustToTerrain(terrain, Terrain.WRAP, camHoversAt);
  cam.camera();
  cam.speed(camSpeed);
  cam.forward.set(cam.lookDir());

  // Tell the terrain what camera to use
  terrain.cam = cam;

  time = millis();
}

void draw(){
  background(0);
  ambientLight(220, 220, 220);
  directionalLight(255,255,255,-100,-200,200);
  // Get elapsed time
  long t = millis() - time;
  time = millis();

  // Update shapes on terrain
  update(t/1000.0f);
  cp = cam.eye (); 


  // Update camera speed and direction
  if(mousePressed){
    float achange = (mouseX - pmouseX) * PI / width;
    // Keep view and move directions the same
    cam.rotateViewBy(achange);
    cam.turnBy(achange);
  }
    if (cp.z - np.z < 5 && -5 < cp.z - np.z && Countdown == true && God == true && Start == true) {
      God = false; 
    droids[0].visible(false);
    droids[0].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 50));
    droids[0].visible(true); 
   NewGame = 1; 
   }
  
   /* if(selected.tagNo > textures.length) {
      droids[0].visible(false);
    boss++; 
    droids[0].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 50));
    droids[0].visible(true);
   } */
   // if (cp.z - np.z < 10 && -10 < cp.z - np.z) {// doesnt work
   // droids[1].visible(false);
   // boss++; 
   // droids[1].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 50));
   // droids[1].visible(true);
  // print (boss);
    //}
  // Update camera speed and direction
  if(keyPressed){
    if(key == 'W' || key =='w' || key == 'P' || key == 'p'){
      camSpeed += ((t/100.0f) *50);
      cam.speed(camSpeed);
    }
    else if(key == 'S' || key =='s' || key == 'L' || key == 'l'){
      camSpeed -= (t/100.0f)* 50;
      cam.speed(camSpeed);
    }
    else if(key == ' '){
      Countdown = true; 
      camSpeed = 0;
      cam.speed(camSpeed);
    }
    else if( key == 'r') { 
      NewGame = 3;  
      textMode(MODEL); 
    }
  }
  //  if ( cp.x == np. x ) && (cp.z == np.x) {
  //  visible(boolean visible == false, int sides);
//  }
  // Calculate amount of movement based on velocity and time
 
  cam.move(t/1000.0f);
  // Adjust the cameras position so we are over the terrain
  // at the given height.
  cam.adjustToTerrain(terrain, Terrain.WRAP, camHoversAt);
  // Set the camera view before drawing
  cam.camera();


 // obelisk.draw();
  //tube.draw();
  if (NewGame == 3) { 
    boss = 0; 
    Start = true; 
    God = true; 
    for(int i = 0; i < nbrDroids; i++){
    droids[i].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 50));
    }
    print("                                                                                        ");
    NewGame = 2; 
    
  } 
 
if (God == false) { 
   text ("YOU LOSE", 250, 300);
   text ("Press R to restart", 220, 350);
    text("you have killed " + boss + " UFO's", 10, (height - 50), (cp.z + 10));  
   textMode(SCREEN); 
   fill(0, 102, 153);
} 

  // Get rid of directional lights so skybox is evenly lit.
 Start(); 
 Play();
}

/**
 * Update artefacts and seekers
 */
public void Start(){ 
if (Countdown == true) { 
     Start = true;
   } 
if (Start == false){ 
    text ("AVOID THE UFO AT ALL COSTS", 0, 300);
    text ("CLICK TO KILL", 0, 350);
    text ("Press Space to begin", 0, 400);
   textMode(SCREEN); 
   fill(0, 102, 153);
}
if (God == true && Start == true){
    terrain.draw();
    noLights();
    skybox.moveTo(cam.eye().x, 0, cam.eye().z);
    skybox.draw();
 } 
}
public void Play() {
  long t = millis() - time;
  time = millis();
  // Update shapes on terrain
  update(t/1000.0f);
  cp = cam.eye (); 
  // Update camera speed and direction
  if(mousePressed){
    float achange = (mouseX - pmouseX) * PI / width;
    // Keep view and move directions the same
    cam.rotateViewBy(achange);
    cam.turnBy(achange);
  }
    if (cp.z - np.z < 5 && -5 < cp.z - np.z) {
      God = false; 
    droids[0].visible(false);
    droids[0].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 50));
    droids[0].visible(true); 
   NewGame = 1; 
   }
   
  if(keyPressed){
    if(key == 'W' || key =='w' || key == 'P' || key == 'p'){
      camSpeed += ((t/100.0f) *50);
      cam.speed(camSpeed);
    }
    else if(key == 'S' || key =='s' || key == 'L' || key == 'l'){
      camSpeed -= (t/100.0f)* 50;
      cam.speed(camSpeed);
    }
    else if(key == ' '){
      camSpeed = 0;
      cam.speed(camSpeed);
    }
    else if( key == 'r') { 
      NewGame = 3;  
      textMode(MODEL); 
    }
  }
  cam.move(t/1000.0f);
  // Adjust the cameras position so we are over the terrain
  // at the given height.
  cam.adjustToTerrain(terrain, Terrain.WRAP, camHoversAt);
  // Set the camera view before drawing
  cam.camera();  
}
public void update(float time){

 // obelisk.rotateBy(0, time*radians(16.9f), 0);
  //tube.rotateBy(time*radians(25.6f), time*radians(6.871f), time*radians(17.3179f));
  for(int i = 0; i < nbrDroids; i++){
    np = PVector.add(droids[i].getPosVec(), PVector.mult(droidDirs[i],time));
    droids[i].moveTo(np);
    droids[i].adjustToTerrain(terrain, Terrain.WRAP, 15);
  }
}

/**
 * Get a random position on the terrain avoiding the edges
 * @param t the terrain
 * @param tsize the size of the terrain
 * @param height height above terrain
 * @return
 */
public PVector getRandomPosOnTerrain(Terrain t, float tsize, float height){
  PVector p = new PVector(random(-tsize/2.1f, tsize/2.1f), 0, random(-tsize/2.1f, tsize/2.1f));
  p.y = t.getHeight(p.x, p.z) - height;
  return p;
}

/**
 * Get random direction for seekers.
 * @param speed
 */
public PVector getRandomVelocity(float speed){
  PVector v = new PVector(random(-10000, 10000), 0 ,random(-10000,10000));
  v.normalize();
  v.mult(speed);
  return v;
}

/**
 * next texture or change color
 */
public void mouseClicked(){// possibly add a function where you click on the droid to make them dissapear and have you die if they hit you.
  cam.camera();
  selected = Shape3D.pickShape(this, mouseX, mouseY);
 // println(selected);
  if(selected != null){
    if(selected.tagNo > textures.length) {
      for(int i = 0; i < nbrDroids; i++){
    droids[i].visible(false);
    droids[i].moveTo(getRandomPosOnTerrain(terrain, terrainSize, 50));
    droids[i].visible(true);
    }
    print ("you got one ");
    boss++; 
   
    }
    else if(selected.tagNo >= 0){
      selected.tagNo = (selected.tagNo + 1) % textures.length;
      selected.setTexture(textures[selected.tagNo]);
    }
  }
}


