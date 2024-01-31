// HINT: Don't forget to define the uniforms here after you pass them in in A3.js

uniform float ticks;

// The value of our shared variable is given as the interpolation between normals computed in the vertex shader
// below we can see the shared variable we passed from the vertex shader using the 'in' classifier
in vec3 interpolatedNormal;
in vec3 lightDirection;
in vec3 vertexPosition;

void main() {
    // HINT: Compute the light intensity the current fragment by determining
    // the cosine angle between the surface normal and the light vector.

    float intensity = max(dot(interpolatedNormal, lightDirection), 0.0);

    // HINT: Pick any two colors and blend them based on light intensity
    // to give the 3D model some color and depth.
    vec3 color1 = vec3(1.0, 0.0, 1.0);
    vec3 color2 = vec3(0.0, 1.0, 1.0);

    vec3 out_Stripe = mix(color1, color2, intensity);

    float modX = mod(vertexPosition.x * 10.0 + ticks / 7.0, 1.0);
    float modY = mod(vertexPosition.y * 10.0 + ticks / 7.0, 1.0);
    float modZ = mod(vertexPosition.z * 10.0 + ticks / 7.0, 1.0);

    if(modX < 0.2 || modY < 0.2 || modZ < 0.2)
    {
        discard;
    }

    // HINT: Set final rendered colour
    gl_FragColor = vec4(out_Stripe, 1.0);
}
