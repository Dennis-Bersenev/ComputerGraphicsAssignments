in vec3 vcsNormal;
in vec3 vcsPosition;
in vec2 texCoord;
in vec4 lightSpaceCoords;

uniform vec3 lightColor;
uniform vec3 ambientColor;

uniform float kAmbient;
uniform float kDiffuse;
uniform float kSpecular;
uniform float shininess;

uniform vec3 cameraPos;
uniform vec3 lightPosition;
uniform vec3 lightDirection;

// Textures are passed in as uniforms
uniform sampler2D colorMap;
uniform sampler2D normalMap;

// Added ShadowMap
uniform sampler2D shadowMap;
uniform float textureSize;

//Q1e do the shadow mapping
//Q1f do PCF
// Returns 1 if point is occluded (saved depth value is smaller than fragment's depth value)
float inShadow(vec3 fragCoord, vec2 offset) {
	float bias = 0.00001;
	vec2 sampleCoords = fragCoord.xy + offset;
	if (sampleCoords.x <= 1.0 && sampleCoords.y <= 1.0 && sampleCoords.x >= 0.0 && sampleCoords.y >= 0.0) {
		float depth = texture2D(shadowMap, sampleCoords).r;
		return (depth + bias) < fragCoord.z ? 1.0 : 0.0;
	}
	else
		return 0.0;
	
}

// Returns a value in [0, 1], 1 indicating all sample points are occluded
float calculateShadow() {
	// Point in light space, [0, 1] range
	vec3 pos = (0.5 * lightSpaceCoords.xyz) + 0.5;
	float depth = texture2D(shadowMap, pos.xy).r;
	float f = 1.0/depth;
	return (depth) < pos.z ? 1.0 : 0.0;
	// Make the step from each texel larger to make each sample farther apart from one another, creates better effect as texture resolution
	// is very large. 
	// float smoothAmt = 0.005;

	// int borderWidth = 5;
	// int dim = (borderWidth * 2) + 1;
	// float sampleSize = float(dim * dim);
	// float stepAmount = 1.0 / smoothAmt;
	// float texelSize = 1.0 / (textureSize); 

	// float count = 0.0;
	// for (int row = -borderWidth; row <= borderWidth; row++) {
	// 	for (int col = -borderWidth; col <= borderWidth; col++) {
	// 		count += inShadow(pos, (stepAmount * texelSize * vec2(row, col)));
	// 	}
	// }
	// return count / sampleSize;
}

void main() {
	//PRE-CALCS
	vec3 N = normalize(vcsNormal);
	vec3 Nt = normalize(texture(normalMap, texCoord).xyz * 2.0 - 1.0);
	vec3 L = normalize(vec3(viewMatrix * vec4(lightDirection, 0.0)));
	vec3 V = normalize(-vcsPosition);
	vec3 H = normalize(V + L);

	//AMBIENT
	vec3 light_AMB = ambientColor * kAmbient;

	//DIFFUSE
	vec3 diffuse = kDiffuse * lightColor;
	vec3 light_DFF = diffuse * max(0.0, dot(N, L));

	//SPECULAR
	vec3 specular = kSpecular * lightColor;
	vec3 light_SPC = specular * pow(max(0.0, dot(H, N)), shininess);

	//SHADOW
	float shadow = 1.0 - calculateShadow();

	//TOTAL
	light_DFF *= texture(colorMap, texCoord).xyz;
	vec3 TOTAL = light_AMB + shadow * (light_DFF + light_SPC);

	gl_FragColor = vec4(TOTAL, 1.0);
}