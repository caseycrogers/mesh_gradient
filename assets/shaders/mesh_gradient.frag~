#version 460 core

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec4 uColor0;
uniform vec4 uColor1;
uniform vec4 uColor2;
uniform vec4 uColor3;

out vec4 FragColor;

void main()
{
    vec2 pixel = FlutterFragCoord() / uSize;
    FragColor = uColor1;
    //FragColor = color_from_coon_surface(vec2(0.0, 0.0), vec2(1.0, 0.0), vec2(1.0, 1.0), vec2(0.0, 1.0), uColor0, uColor1, uColor2, uColor3, pixel.x, pixel.y);
}

vec4 color_from_coon_surface(
vec2 p0,
vec2 p2,
vec2 p3,
vec2 p4,
vec4 color0,
vec4 color1,
vec4 color2,
vec4 color3,
float u,
float v
) {
    vec4 colorC1 = mix(surface.color0, surface.color1, u);
    vec4 colorC2 = mix(surface.color3, surface.color2, u);
    return mix(colorC1, colorC2, 1 - v);
}