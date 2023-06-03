#version 460 core

#include <flutter/runtime_effect.glsl>

#define PI 3.1415926538

uniform vec2 uSize;
uniform float strength;

uniform sampler2D uTexture;

out vec4 FragColor;

void main()
{
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv = FlutterFragCoord().xy / uSize;
    float minAxis = min(uSize.x, uSize.y);
    vec2 norm = vec2(
        (coord.x - (uSize.x - minAxis) / 2) / minAxis,
        (coord.y - (uSize.y - minAxis) / 2) / minAxis
    ) * 2 - 1;
    float distance = length(norm);
    float angle = mod(atan(norm.y, norm.x) + 2 * PI, 2*PI) / (2 * PI);
    vec2 polarCoord = vec2(distance, angle);

    vec2 lerpedCoord = mix(uv, vec2(polarCoord.t, polarCoord.r), strength);
    if (lerpedCoord.t > 1) {
        FragColor = vec4(0, 0, 0, 1);
        return;
    }
    FragColor = texture(uTexture, lerpedCoord);
}