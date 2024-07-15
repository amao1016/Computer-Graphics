public abstract class Material{
    Vector3 albedo = new Vector3(0.9,0.9,0.9);
    Shader shader;
    Texture texture;
    Material(){
        // In the Material, pass the relevant attribute variables and uniform variables you need. 
        // In the attribute variables, include relevant variables about vertices, 
        // and in the uniform, pass other necessary variables. 
        // Please note that a Material will be bound to the corresponding Shader.
    }    
    abstract Vector4[][] vertexShader(Triangle triangle,Matrix4 M);//M 是 localtoWorld()      
    abstract Vector4 fragmentShader(Vector3 position,Vector4[] varing);    
    void attachShader(Shader s){
        shader = s;
    }
}

public class DepthMaterial extends Material{
    DepthMaterial(){
        shader =  new Shader(new DepthVertexShader(), new DepthFragmentShader());
    }
    Vector4[][] vertexShader(Triangle triangle,Matrix4 M){
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector4[][] r = shader.vertex.main(new Object[]{position},new Object[]{MVP});
        return r;
    }
    
    Vector4 fragmentShader(Vector3 position,Vector4[] varing){
        return shader.fragment.main(new Object[]{position});
    }
}

public class PhongMaterial extends Material{
    Vector3 Ka = new Vector3(0.3,0.3,0.3);
    float Kd = 0.5;
    float Ks = 0.5;
    float m = 20;
    PhongMaterial(){
        shader = new Shader(new PhongVertexShader(),new PhongFragmentShader());
    }
    
    Vector4[][] vertexShader(Triangle triangle,Matrix4 M){
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        Vector3[] normal = triangle.normal;
        Vector4[][] r = shader.vertex.main(new Object[]{position,normal},new Object[]{MVP,M});
        return r;
    }
    
    Vector4 fragmentShader(Vector3 position,Vector4[] varing){
        if(texture!=null)albedo = getTexture(texture.texture, position);
        return shader.fragment.main(new Object[]{position,varing[0].xyz(),varing[1].xyz(),albedo,new Vector3(Kd,Ks,m)});
    }

}

public class FlatMaterial extends Material{
    Vector3 Ka = new Vector3(0.3,0.3,0.3);
    float Kd = 0.5;
    float Ks = 0.5;
    float m = 20;
    FlatMaterial(){
        shader =  new Shader(new FlatVertexShader(), new FlatFragmentShader());
    }
    Vector4[][] vertexShader(Triangle triangle,Matrix4 M){
        Matrix4 MVP = main_camera.Matrix().mult(M);
        Vector3[] position = triangle.verts;
        
        // To - Do (HW4)
        // pass the uniform you need into the shader.
        Vector3[] normal = triangle.normal;
        
        Vector4[][] r = shader.vertex.main(new Object[]{position,normal},new Object[]{MVP,M,albedo,new Vector3(Kd,Ks,m)});
        return r;
    }
    
    Vector4 fragmentShader(Vector3 position,Vector4[] varing){
        return shader.fragment.main(new Object[]{position,varing[0]});
    }
}

public class GroundMaterial extends Material{
    Vector3 Ka = new Vector3(0.3,0.3,0.3);
    float Kd = 0.5;
    float Ks = 0.5;
    float m = 20;
    GroundMaterial(){
        shader =  new Shader(new GroundVertexShader(), new GroundFragmentShader());
    }
    Vector4[][] vertexShader(Triangle triangle,Matrix4 M){
        Matrix4 MVP = main_camera.Matrix().mult(M);
        //todo
        Vector3[] position = triangle.verts;
        Vector3[] normal = triangle.normal;
        Vector4[][] r = shader.vertex.main(new Object[]{position,normal},new Object[]{MVP,M,albedo,new Vector3(Kd,Ks,m)});
        return r;
    }
    
    Vector4 fragmentShader(Vector3 position,Vector4[] varing){
        
        return shader.fragment.main(new Object[]{position,varing[0]});
    }
}

public enum MaterialEnum{
    DM,FM,GM,PM;
}
