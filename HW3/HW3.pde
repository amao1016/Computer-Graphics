import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public Vector4 renderer_size;
static public float GH_FOV = 45.0f;
static public float GH_NEAR_MIN = 1e-3f;
static public float GH_NEAR_MAX = 1e-1f;
static public float GH_FAR = 1000.0f;

public boolean debug = true;

public float[] GH_DEPTH;
public PImage renderBuffer;

Engine engine;
Camera main_camera;
Vector3 cam_position;
Vector3 lookat;

void setup(){
   size(1000,600);
   renderer_size = new Vector4(20,50,520,550);
   cam_position = new Vector3(0,-5,-5);
   lookat = new Vector3(0,0,0);
   setDepthBuffer();   
   main_camera = new Camera();
   engine = new Engine(); 
     
}

void setDepthBuffer(){
    renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
    GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
    for(int i = 0 ; i < GH_DEPTH.length;i++){
        GH_DEPTH[i] = 1.0;
        renderBuffer.pixels[i] = color(1.0*250);
    }
}

void draw(){
    background(255);
    
    engine.run();
    cameraControl();
}

String selectFile(){
    JFileChooser fileChooser = new JFileChooser();      
    fileChooser.setCurrentDirectory(new File("."));
    fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
    fileChooser.setFileFilter(filter);

    int result = fileChooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
        String filePath = fileChooser.getSelectedFile().getAbsolutePath();
        return filePath;
    }
    return "";
}

void cameraControl(){
    // To - Do 
    // You can write your own camera control function here.
    // Use setPositionOrientation(Vector3 position,Vector3 lookat) to modify the ViewMatrix.
    // Hint : Use keyboard event and mouse click event to change the position of the camera.
    if(isMouseInRegion())
    {
        if (mousePressed && (mouseButton == LEFT)) //拖曳控制XY
        {
            float deltaX = radians(mouseX - pmouseX) ;
            float deltaY = radians(mouseY - pmouseY) ;
            //println("deltax:",deltaX,"    delataY:",deltaY);
            cam_position.x -= deltaX;
            cam_position.y -= deltaY;
            //lookat.x += deltaX;
            //lookat.y += deltaY;
            main_camera.setPositionOrientation(cam_position, lookat);
        }
    }

}
void mouseWheel(MouseEvent event)//滾輪控制Z
{
    if(isMouseInRegion())
    {
        float deltaZ = event.getCount();
        cam_position.z -= deltaZ;
        lookat.z -=deltaZ;
        main_camera.setPositionOrientation(cam_position, lookat);
    }
}
boolean isMouseInRegion()
{
      return mouseX >= renderer_size.x && mouseX <= renderer_size.z && mouseY >= renderer_size.y && mouseY <= renderer_size.w; //20,50,520,500
}
