float GRAVITATIONAL_CONSTANT = 30;
float NEW_PLANET_SPEED_CREATION = 50;
float MIN_DIST = 50;
float BASE_SPEED = 1;

float time;

ArrayList<Planet> planets;

int createNewX, createNewY;
boolean creatingNewPlanet = false;
float newPlanetRadius = 0;
color newPlanetColor;

boolean creatingArrow = false;

void setup() {
  size(800, 800);
  planets = new ArrayList<Planet>();
  time = millis();
}

void draw() {
  background(#3d3d3d);

  for(Planet p : planets) {
    p.resetAccel();
  }

  for(int i = 0;i<planets.size()-1; i++) {
    for(int j = i+1;j<planets.size();j++) {
      planetInteraction(planets.get(i),planets.get(j));
    }
  }

  stroke(#333333);
  for(Planet p : planets) {
    p.updateCinematics((millis()-time)/1000);
    p.drawPlanet();
  }

  cleanUp();

  if(creatingNewPlanet) {
    newPlanetRadius += NEW_PLANET_SPEED_CREATION*(millis()-time)/1000;
    fill(newPlanetColor);
    stroke(#333333);
    ellipse(createNewX,createNewY,2*newPlanetRadius,2*newPlanetRadius);
  }

  if(creatingArrow) {
    ellipse(createNewX,createNewY,2*newPlanetRadius,2*newPlanetRadius);
    drawArrow(createNewX,createNewY,mouseX,mouseY);
  }
  
  time = millis();
}

void mousePressed() {
  if(!creatingArrow) {
    createNewX = mouseX;
    createNewY = mouseY;
    creatingNewPlanet = true;
    newPlanetColor = color(random(255),random(255),random(255));
  } else {
    PVector arrowDir = new PVector(mouseX-createNewX,mouseY-createNewY);
    planets.add(new Planet(
      newPlanetRadius,
      newPlanetColor,
      new PVector(createNewX,createNewY),
      arrowDir.mult(BASE_SPEED)
    ));
    newPlanetRadius = 0;
  }
}

void mouseReleased() {
  if(!creatingArrow) {
    creatingNewPlanet = false;
    creatingArrow = true;
  } else {
    creatingArrow = false;
  }
}
 
void planetInteraction(Planet p1, Planet p2) {
  float dist = p1.position.dist(p2.position);
  if(dist < MIN_DIST)
    dist = MIN_DIST;
  float force = GRAVITATIONAL_CONSTANT*p1.weight*p2.weight/(dist*dist);

  PVector directionP1 = p2.position.copy().sub(p1.position);
  directionP1.setMag(force);
  PVector directionP2 = directionP1.copy().mult(-1);

  p1.accel.add(directionP1.div(p1.weight));
  p2.accel.add(directionP2.div(p2.weight));
}

void cleanUp() {
  IntList toRemove = new IntList();

  for(int i = 0; i < planets.size(); i++)
    if(abs(planets.get(i).position.x)/2 > width || abs(planets.get(i).position.y)/2 > height)
      toRemove.append(i);

  for(int i = toRemove.size()-1;i >= 0; i--) {
    planets.remove(toRemove.get(i));
  }
}

void drawArrow(int x1, int y1, int x2, int y2) {
  stroke(#efefef);
  strokeWeight(4);
  line(x1, y1, x2, y2);

  pushMatrix();
    translate(x2, y2);
    rotate(atan2(x1-x2, y2-y1));
    line(0, 0, -10, -10);
    line(0, 0, 10, -10);
  popMatrix();
} 
