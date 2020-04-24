public class Planet {
  float radius;
  float weight;
  PVector position;
  PVector speed;
  PVector accel;
  color cor;
  boolean moves;

  public Planet(float r, color c, PVector p, PVector s) {
    this.radius = r;
    this.position = p;
    this.speed = s;
    this.cor = c;
    this.moves = true;
    this.accel = new PVector(0,0);
    this.weight = 4*PI*this.radius*this.radius*this.radius/3;
  }

  public void drawPlanet() {
    fill(cor);
    ellipse(position.x,position.y,2*radius,2*radius);
  }

  public void resetAccel() {
    this.accel = new PVector(0,0);
  }

  public void updateCinematics(float timePassed) {
    if(moves) {
      this.speed.add(this.accel.copy().mult(timePassed));
      this.position.add(this.speed.copy().mult(timePassed));
    }
  }

  public void makeStatic() {
    this.speed = new PVector(0,0);
    this.moves = false;
  }
  public void makeMovable() {
    this.moves = true;
  }
}
