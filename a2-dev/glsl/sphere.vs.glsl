uniform float time;

out vec3 interpolatedNormal;

const float PI = 3.14159;
vec3 modifiedPosition(vec3 pointPosition)
{
    float amplitude = 0.5+0.5*sin(time);
    vec3 r = normalize(pointPosition);
    return pointPosition + amplitude  *  sin (PI * r);
}

void main() {

    interpolatedNormal = normal;

    vec3 modifiedPos = modifiedPosition(position);

    // Multiply each vertex by the model matrix to get the world position of each vertex, 
    // then the view matrix to get the position in the camera coordinate system, 
    // and finally the projection matrix to get final vertex position.
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(modifiedPos, 1.0);
}
