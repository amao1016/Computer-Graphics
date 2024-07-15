public class Camera {
    Matrix4 projection=new Matrix4();
    Matrix4 worldView=new Matrix4();
    int wid;
    int hei;
    float near;
    float far;
    Transform transform;
    Camera() {
        wid=256;
        hei=256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform = new Transform();
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }


    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        // To - Do
        // This function takes four parameters, which are the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.
        //projection.makeIdentity();
        float tan = tan(GH_FOV*2*PI/360.0f);
        projection.m[0] = 1;
        projection.m[5] = w/h;
        projection.m[10] = far/(far-near)*tan;
        projection.m[11] = near*far/(near-far)*tan;
        projection.m[14] = tan;        
    }
    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {

    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // To - Do
        // This function takes two parameters, which are the position of the camera and the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.
        
        //首先處理相機的UVN三個向量方向
        //已知前向量N=lookat-pos，假設(0,1,0)和前向量形成平面，叉積即得右向量U。
        //NU叉積得上向量V
        Vector3 N = Vector3.sub(lookat,pos);//前
        Vector3 U = Vector3.cross(new Vector3(0,1,0),N);//右
        Vector3 V = Vector3.cross(N,U);//上
        //normalize
        N.normalize();
        V.normalize();
        U.normalize();
        Matrix4 R = new Matrix4(U,V,N);
        R.m[15]=1.0f;
        Matrix4 T = Matrix4.Trans(pos.mult(-1));
        T.m[15]=1.0f;
        worldView = R.mult(T);
        //print(worldView.toString());
    }
}
