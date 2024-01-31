//Q1d implement the whole thing to map the depth texture to a quad
uniform mat4 lightProjMatrix;
uniform mat4 lightViewMatrix;

out vec2 v_UV;
out vec4 lightSpaceCoords;

void main() {
    v_UV = uv;    
    mat4 lightSpaceMatrix = lightProjMatrix * lightViewMatrix;
    lightSpaceCoords = lightSpaceMatrix * modelMatrix * vec4( position, 1.0 );
    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4( position, 1.0 );

}