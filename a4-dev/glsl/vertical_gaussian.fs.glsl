in vec2 vUV;

uniform sampler2D sceneInput;
uniform float screenHeight;

// 5 x 5 filter (1D pass)
uniform float weights[7];

void main() {
    int borderWidth = 3;
    float pixelSize = 1.0 / (screenHeight * 0.5); 
    float offset;
    vec2 newCoord;
    vec4 outColor = vec4(0.0);
    for (int i = -borderWidth; i <= borderWidth; i++) {
        offset = pixelSize * float(i);
        newCoord = vUV + vec2(0.0, offset);
        if (newCoord.y >= 0.0 && newCoord.y <= 1.0 ) 
            outColor += weights[i + 3] * texture2D(sceneInput, newCoord);
	}
    gl_FragColor = outColor;
}