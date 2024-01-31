// Textures are passed in as uniforms
uniform sampler2D colorMap;
uniform sampler2D normalMap;

in vec2 texCoord;

void main() {
    vec3 texc = texture(colorMap, texCoord).xyz;
	// gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
    gl_FragColor = vec4(texc, 1.0);
}