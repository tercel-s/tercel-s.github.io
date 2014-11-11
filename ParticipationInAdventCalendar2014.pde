State state;

void setup() {
  size(400, 300, P3D);  
  frameRate(20);
  
  fill(255);
  noStroke();
  
  state = new Opening();
}

void draw() {
  background(255);
  camera();

  state = state.update(); 
}
class Opening implements State {
  private final int N = 15;
  private final int[] timers;

  private float  cameraAngle;
  private PImage tex;

  public Opening() {
    // ----------------------------------------
    // タイマー用の変数を初期化
    timers = new int[N * N];    
    for(int i = 0; i < N; ++i) {
      for(int j = 0; j < N; ++j) {
        timers[i * N + j] = 100 + i + j;
      }
    }
    cameraAngle = 100;
    tex = loadImage("./background.png");
  }
  
  
  State update() {
    final float partWidth  = (float)width  / N;
    final float partHeight = (float)height / N;
    
    final float MAX_SPEED = 20;
    final float MAX_ANGULAR_RATE = 10;
    
    background(255);
    fill(255);
    camera();
    
    randomSeed(0);
    
    cameraAngle = cameraAngle > 0 ? cameraAngle - 1 : 0;

    final float MAX_CAMERA_ANGULAR_RATE = 1.5;
    // ------------------------------------------------------------
    // カメラの回転操作
    translate( 0.5 * width,  0.5 * height, 0);                                                 // ⑤ ①の並進移動をリセット
    rotateZ(radians(random(-MAX_CAMERA_ANGULAR_RATE, MAX_CAMERA_ANGULAR_RATE) * cameraAngle)); // ④ y軸まわりに回転
    rotateY(radians(random(-MAX_CAMERA_ANGULAR_RATE, MAX_CAMERA_ANGULAR_RATE) * cameraAngle)); // ③ y軸まわりに回転
    rotateX(radians(random(-MAX_CAMERA_ANGULAR_RATE, MAX_CAMERA_ANGULAR_RATE) * cameraAngle)); // ② x軸まわりに回転
    translate(-0.5 * width, -0.5 * height, 0);                                                 // ① 投影面中心を原点(0, 0, 0)に合わせる
    // ------------------------------------------------------------
    
    for(int i = 0; i < N ; ++i) {
      for(int j = 0; j < N ; ++j) {
        pushMatrix();

        int coef = max(0, --timers[i * N + j]);

        translate((i + 0.5) * partWidth, 
                  (j + 0.5) * partHeight, 
                  0);
        
        translate(random(-MAX_SPEED, MAX_SPEED) * coef,
                  random(-MAX_SPEED, MAX_SPEED) * coef,
                  random(-MAX_SPEED, MAX_SPEED) * coef);
        
        rotateX(radians(random(-MAX_ANGULAR_RATE, MAX_ANGULAR_RATE) * coef));
        rotateY(radians(random(-MAX_ANGULAR_RATE, MAX_ANGULAR_RATE) * coef));
        rotateZ(radians(random(-MAX_ANGULAR_RATE, MAX_ANGULAR_RATE) * coef));

        beginShape();
        texture(tex);
        
        vertex(-0.5 * partWidth, -0.5 * partHeight, 0, i * partWidth, j * partHeight);
        vertex(-0.5 * partWidth,  0.5 * partHeight, 0, i * partWidth, (j+1) * partHeight);
        vertex( 0.5 * partWidth,  0.5 * partHeight, 0, (i+1) * partWidth, (j+1) * partHeight);
        vertex( 0.5 * partWidth, -0.5 * partHeight, 0, (i+1) * partWidth, j * partHeight);

        endShape(CLOSE);
        
        popMatrix();
      }
    }
    
    return this;
  }
}
interface State {
  State update();
}

