uniform float uTime;           // Uniform for animation timing
attribute vec3 color;          // Per-vertex color
varying vec3 vColor;           // Pass color to the fragment shader
attribute vec3 aRandomness;
attribute float aScale;

void main()
{
    // Base model position after applying transformations
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    // Calculate the angle and distance to the center (XZ plane)
    float angle = atan(modelPosition.x, modelPosition.z);           // Particle angle from the center
    float distanceToCenter = length(modelPosition.xz);              // Distance from the center

    // Calculate angle offset (particles closer to the center rotate faster)
    float angleOffset = (1.0 / distanceToCenter) * uTime * 0.2;     // Offset angle (slower further from center)
    angle += angleOffset;                                           // Update angle with offset

    // Update the position using cos and sin, scaled by the initial distanceToCenter
    modelPosition.x = cos(angle) * distanceToCenter;                // Recalculate X position
    modelPosition.z = sin(angle) * distanceToCenter;                // Recalculate Z position

    // Randomness
    modelPosition.xyz += aRandomness;

    // Transform position using the view and projection matrices
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    // Point size attenuation (optional)
    gl_PointSize = 2.0;
    gl_PointSize *= (1.0 / -viewPosition.z);

    // Pass color to fragment shader
    vColor = color;
}
