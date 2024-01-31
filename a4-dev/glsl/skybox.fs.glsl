// The cubmap texture is of type SamplerCube

uniform samplerCube skybox;
in vec3 wcsPosition;


void main() {

	// HINT : Sample the texture from the samplerCube object, rememeber that cubeMaps are sampled 
	// using a direction vector that you calculated in the vertex shader 
	gl_FragColor = texture(skybox, wcsPosition);  //Q3 Answer, looking up shader color from texturemap
}