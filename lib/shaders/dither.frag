#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uSize;
uniform float uThresholdDimension;
uniform float uColorPower;

uniform sampler2D uTexture;
uniform sampler2D uThresholdMap;

out vec4 fragColor;

vec3 hsb2rgb( vec3 c ){
    vec3 rgb = clamp(abs(mod(c.x*6.0+vec3(0.0,4.0,2.0),
    6.0)-3.0)-1.0,
    0.0,
    1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

void main() {
    // n entries in the threshold map.
    float n = pow(uThresholdDimension, 2);
    // n + 1 potential patterns (the extra pattern is for all pixels on).
    float patternCount = n + 1.;
    float effectiveColors = n * (uColorPower) + 1;
    vec2 coord = FlutterFragCoord().xy;
    vec2 uv = FlutterFragCoord().xy / uSize;
    //fragColor = texture(uThresholdMap, floor(uv * 4));

    vec4 c = vec4(0);
    // Linear gradient for testing.
    //c = c + vec4(1 - uv.y, 1 - uv.y, 1 - uv.y, 1);
    // Full color graident for testing.
    c = c + vec4(hsb2rgb(vec3(uv.y, 1, 1)), 1.0);
    // Downsampled by a factor of 1.
    //c = c + texture(uTexture, uv);
    // Downsampled by a factor of 2.
    //c = c + texture(uTexture, uv / 2.) / 4.;
    //c = c + texture(uTexture, round(coord/2.) * 2. / uSize + vec2(1., 0.)) / 4.;
    //c = c + texture(uTexture, round(coord/2.) * 2. / uSize + vec2(0., 1.)) / 4.;
    //c = c + texture(uTexture, round(coord/2.) * 2. / uSize + vec2(1., 1.)) / 4.;
    // Downsampled by a factor of 5.
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., -2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., -2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., -2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., -2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., -2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., -1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., -1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., -1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., -1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., -1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., 0.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., 0.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., 0.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., 0.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., 0.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., 1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., 1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., 1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., 1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., 1.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-2., 2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-1., 2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(-0., 2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(1., 2.)) / 25.;
    //c = c + texture(uTexture, round(coord/5.) * 5. / uSize + vec2(2., 2.)) / 25.;

    if (uv.x > (.5)) {
        fragColor = floor(c * uColorPower) / uColorPower;
        return;
    }


    float threshold = texture(uThresholdMap, mod(floor(coord), uThresholdDimension)).r;
    fragColor = vec4(0, 0, 0, 1) + threshold;
    float r = 1. / uColorPower;
    // if uColorPower = 2: 13 / 12
    // if uColorPower = 2: 9 / 8
    // if uColorPower = 1: 5 / 4
    vec4 thresholdedPixel = c * ((effectiveColors) / (effectiveColors - 1)) + r*(threshold);
    vec4 bandedPixel = vec4(
    floor(thresholdedPixel.r * uColorPower) / uColorPower,
    floor(thresholdedPixel.g * uColorPower) / uColorPower,
    floor(thresholdedPixel.b * uColorPower) / uColorPower,
    1
    );
    //fragColor = texture(uThresholdMap, floor(uv*uThresholdDimension));
    fragColor = bandedPixel;
}
