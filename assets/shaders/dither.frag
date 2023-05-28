#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uThresholdDimension;
uniform float uColorPower;
uniform sampler2D uTexture;
uniform sampler2D uThresholdMap;

out vec4 fragColor;

void main() {
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv = FlutterFragCoord().xy / uSize;
    float threshold = texture(uThresholdMap, mod(coord, uThresholdDimension - 1)).r;
    vec4 c = texture(uTexture, uv / 2.) / 4.;
    c = c + texture(uTexture, round(coord/2.) * 2. / uSize + vec2(1., 0.)) / 4.;
    c = c + texture(uTexture, round(coord/2.) * 2. / uSize + vec2(0., 1.)) / 4.;
    c = c + texture(uTexture, round(coord/2.) * 2. / uSize + vec2(1., 1.)) / 4.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., -2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., -2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., -2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., -2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., -2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., -1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., -1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., -1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., -1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., -1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., 0.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., 0.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., 0.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., 0.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., 0.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., 1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., 1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., 1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., 1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., 1.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., 2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., 2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., 2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., 2.));
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., 2.));
    float r = 255.0 / uColorPower;
    vec4 thresholdedPixel = c + r*(threshold-.5);
    vec4 bandedPixel = vec4(
    round(thresholdedPixel.r*uColorPower)/uColorPower,
    round(thresholdedPixel.b*uColorPower)/uColorPower,
    round(thresholdedPixel.g*uColorPower)/uColorPower,
    thresholdedPixel.a
    );
    fragColor = c + vec4(0, 0, 0 , 1);
}
