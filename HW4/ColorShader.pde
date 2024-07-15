public class PhongVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }
        
        Vector4[][] result = {gl_Position,w_position,w_normal};
        
        return result;
    }
}
// In material, return shader.fragment.main(new Object[]{position,varing[0].xyz(),varing[1].xyz(),albedo,new Vector3(Kd,Ks,m)});
public class PhongFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 position = (Vector3)varying[0];
        Vector3 w_position = (Vector3)varying[1];
        Vector3 w_normal = (Vector3)varying[2];
        Vector3 albedo = (Vector3) varying[3];  //object color
        Vector3 kdksm = (Vector3) varying[4];  //specular cosm
        Light light = basic_light;
        Camera cam = main_camera;
        // To - Do (HW4)
        float dis = Vector3.sub(light.transform.position,w_position).norm();
        //float lightAnnu = 1.0/(1.0 + 0.1*dis);    
        Vector3 lightDir = Vector3.sub(light.transform.position,w_position).unit_vector();
        
        //diffuse
        float diffuse = max(Vector3.dot(w_normal,lightDir), 0.0);
        //specular 
        Vector3 viewDir = Vector3.sub(cam.transform.position,w_position).unit_vector();
        Vector3 reflectDir = w_normal.mult(2.0 * Vector3.dot(w_normal,lightDir)).sub(lightDir).unit_vector();  //2(N.L)N-L
        float specular = pow(max(Vector3.dot(viewDir,reflectDir), 0.0), kdksm.z);//(R.V)^m

        //formula = Ka.Ia.Od + Kd.Ip(N.L).Od + Ks.Ip.(R.V)^m
        Vector3 result = AMBIENT_LIGHT.product(light.light_color.product(albedo)) //Ka*Ia*Od
                        .add(albedo.mult(diffuse*kdksm.x))     //Kd(N.L)Od
                        .add(new Vector3(specular*kdksm.y));   // Ks.Ip.(R.V)^m

        return new Vector4(result.x, result.y, result.z, 1.0);        
       }
}



public class FlatVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector3 albedo = (Vector3) uniform[2];  //object color
        Vector3 kdksm = (Vector3) uniform[3];  //specular cosm
        
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] shadcolor = new Vector4[3];    
        // To - Do (HW4)
        Vector3 w_position = M.mult(aVertexPosition[0].getVector4(1.0)).xyzNormalize();
        Vector3 w_normal = M.mult(aVertexNormal[0].getVector4(0.0)).xyzNormalize();
        Light light = basic_light;
        Camera cam = main_camera;
        // To - Do (HW4)
        Vector3 lightDir = Vector3.sub(light.transform.position,w_position).unit_vector();
        
        //diffuse
        float diffuse = max(Vector3.dot(w_normal,lightDir), 0.0);
        //specular 
        Vector3 viewDir = Vector3.sub(cam.transform.position,w_position).unit_vector();
        Vector3 reflectDir = w_normal.mult(2.0 * Vector3.dot(w_normal,lightDir)).sub(lightDir).unit_vector();  //2(N.L)N-L
        float specular = pow(max(Vector3.dot(viewDir,reflectDir), 0.0), kdksm.z);//(R.V)^m
        //formula = Ka.Ia.Od + Kd.Ip(N.L).Od + Ks.Ip.(R.V)^m
        Vector3 lightformula = AMBIENT_LIGHT.product(light.light_color.product(albedo)) //Ka*Ia*Od
                        .add(albedo.mult(diffuse*kdksm.x))     //Kd(N.L)Od
                        .add(new Vector3(specular*kdksm.y));   // Ks.Ip.(R.V)^m
        for(int i=0;i<gl_Position.length;i++)
        {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            shadcolor[i] = lightformula.getVector4();
        }
        Vector4[][] result = {gl_Position,shadcolor};

        return result;
    }
}

public class FlatFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector4 shadcolor = (Vector4)varying[1];
        // To - Do (HW4)
        return shadcolor;
    }
}



public class GroundVertexShader extends VertexShader{
    Vector4[][] main(Object[] attribute,Object[] uniform){
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector3 albedo = (Vector3) uniform[2];  //object color
        Vector3 kdksm = (Vector3) uniform[3];  //specular cosm
        
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] shadcolor = new Vector4[3];    
        // To - Do (HW4)
        Vector3[] w_position = new Vector3[3];
        Vector3[] w_normal = new Vector3[3];
        Light light = basic_light;
        Camera cam = main_camera;
        // To - Do (HW4)
        float diffuse, specular;
        for(int i=0;i<gl_Position.length;i++)
        {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0)).xyzNormalize();
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0)).xyzNormalize();
        
            Vector3 lightDir = Vector3.sub(light.transform.position,w_position[i]).unit_vector();
            //diffuse
            diffuse = max(Vector3.dot(w_normal[i],lightDir), 0.0);
            //specular 
            Vector3 viewDir = Vector3.sub(cam.transform.position,w_position[i]).unit_vector();
            Vector3 reflectDir = w_normal[i].mult(2.0 * Vector3.dot(w_normal[i],lightDir)).sub(lightDir).unit_vector();  //2(N.L)N-L
            specular = pow(max(Vector3.dot(viewDir,reflectDir), 0.0), kdksm.z);//(R.V)^m
        //formula = Ka.Ia.Od + Kd.Ip(N.L).Od + Ks.Ip.(R.V)^m
            Vector3 lightformula = AMBIENT_LIGHT.product(light.light_color.product(albedo)) //Ka*Ia*Od
                            .add(albedo.mult(diffuse*kdksm.x))     //Kd(N.L)Od
                            .add(new Vector3(specular*kdksm.y));   // Ks.Ip.(R.V)^m
            shadcolor[i]=lightformula.getVector4();
        }
        Vector4[][] result = {gl_Position,shadcolor};

        return result;
    }
}

public class GroundFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector4 shadcolor = (Vector4)varying[1];
        // To - Do (HW4)
        return shadcolor;
    }
}
