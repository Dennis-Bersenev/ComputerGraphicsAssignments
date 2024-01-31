in vec3 vcsNormal;
in vec3 vcsPosition;

uniform vec3 lightDirection;

uniform samplerCube skybox;

uniform mat4 matrixWorld;

void main( void ) {

  // Q4 : Calculate the vector that can be used to sample from the cubemap
  vec3 I = normalize(vcsPosition);
  vec3 N = normalize(vcsNormal);
  vec3 invert = vec3(1.0, 1.0, 1.0); // used to produce different reflection effects
  vec3 vcsR = invert * reflect(I,N);
  vec4 R = inverse(matrixWorld) * vec4(vcsR,0.0);

  gl_FragColor = texture(skybox, R.xyz);
}