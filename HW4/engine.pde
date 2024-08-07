public class Engine{        
    Renderer renderer;
    Inspector inspector;
    Hierarchy hierarchy;
    
    Vector3[] boundary = {new Vector3(-1,-1,0),new Vector3(-1,1,0),new Vector3(1,1,0),new Vector3(1,-1,0)};
    
    ArrayList<ShapeButton> shapeButton = new ArrayList<ShapeButton>();
    ShapeButton selctFileButton;
    ShapeButton DegubButton;
    ShapeButton refreshButton;
    
    public Engine(){
        renderer = new Renderer();
        inspector = new Inspector();
        hierarchy = new Hierarchy(renderer.gameObject);
        main_camera.setSize(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y) , GH_NEAR_MAX , GH_FAR);
        main_camera.setPositionOrientation();
        basic_light = new Light();        
        initButton();        
        
    } 
    
    public void initButton(){
        selctFileButton = new ShapeButton(20,10,30,30){

        };
        
        
        
        selctFileButton.setBoxAndClickColor(color(250),color(150));
        selctFileButton.setImage(loadImage("cube.png"));
        shapeButton.add(selctFileButton);
        
        DegubButton =  new ShapeButton(60,10,30,30);
        DegubButton.setBoxAndClickColor(color(250),color(150));
        DegubButton.setImage(loadImage("debug.png"));
        
        
        refreshButton =  new ShapeButton(900,10,30,30);
        refreshButton.setBoxAndClickColor(color(250),color(150));
        refreshButton.setImage(loadImage("refresh.png"));
    }
    
   
    
    void run(){      
       setDepthBuffer();
       renderer.run();
       inspector.run();
       hierarchy.run();
       
       
       for(ShapeButton sb:shapeButton){
            sb.run( () -> {
               String path = selectFile();
               //try{
               if(path!="")renderer.addGameObject(new GameObject(path));
               //}catch(Exception ex){
              //     println("Occure some error. Please change another files");
              // }
            });
        } 
        
        DegubButton.run(()->{
            debug = !debug;
        });
        refreshButton.run(() -> {
          if(engine.inspector.gameObject.getGameObjectName()!="Camera")
          {
            engine.inspector.position_slider[0].setValue(0);
            engine.inspector.position_slider[1].setValue(0);
            engine.inspector.position_slider[2].setValue(0);
            engine.inspector.rotation_slider[0].setValue(0);
            engine.inspector.rotation_slider[1].setValue(0);
            engine.inspector.rotation_slider[2].setValue(0);
            engine.inspector.scale_slider[0].setValue(1);
            engine.inspector.scale_slider[1].setValue(1);
            engine.inspector.scale_slider[2].setValue(1);
            engine.inspector.object_color_slider[0].setValue(0.8);
            engine.inspector.object_color_slider[1].setValue(0.8);
            engine.inspector.object_color_slider[2].setValue(0.8);
          }
          else
          {
            engine.inspector.position_slider[0].setValue(0);
            engine.inspector.position_slider[1].setValue(15);
            engine.inspector.position_slider[2].setValue(-50);
            engine.inspector.rotation_slider[0].setValue(0);
            engine.inspector.rotation_slider[1].setValue(0);
            engine.inspector.rotation_slider[2].setValue(0);
            engine.inspector.scale_slider[0].setValue(1);
            engine.inspector.scale_slider[1].setValue(1);
            engine.inspector.scale_slider[2].setValue(1);
          }
        });
       main_camera.setPositionOrientation();
       
    }
    
    
}
