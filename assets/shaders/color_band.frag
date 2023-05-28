#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uColorPower;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
    vec2 uv = FlutterFragCoord().xy / uSize;
    vec4 oldPixel = texture(uTexture, uv);
    vec4 newPixel = vec4(
        round(oldPixel.r*uColorPower)/uColorPower,
        round(oldPixel.b*uColorPower)/uColorPower,
        round(oldPixel.g*uColorPower)/uColorPower,
        oldPixel.a
    );
    fragColor = newPixel;
}