//Q1d implement the whole thing to map the depth texture to a quad
in vec2 v_UV;
in vec4 lightSpaceCoords;

uniform sampler2D tDiffuse;
uniform sampler2D tDepth;

void main() {
    float depth = texture2D(tDepth, v_UV).r;
    gl_FragColor = vec4(vec3(depth), 1.0);
}