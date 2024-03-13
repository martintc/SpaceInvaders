//
//  Shaders.metal
//  SpaceInvaders
//
//  Created by Todd Martin on 2/16/24.
//

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct Vertex {
    float3 position [[attribute(0)]];
    float3 texCoord [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 texCoord;
};

struct VertexUniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut vertexShader(Vertex in [[stage_in]],
                              constant VertexUniforms &uniforms [[buffer(1)]])
{
    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * float4(in.position, 1.0);
    out.texCoord = in.texCoord;
    return out;
}

fragment float4 fragmentShader(VertexOut in [[stage_in]], texture2d<float> colorTexture [[texture(0)]])
{
    constexpr sampler colorSampler(mip_filter::nearest, mag_filter::nearest, min_filter::nearest);
    float4 color = colorTexture.sample(colorSampler, float2(in.texCoord[0], in.texCoord[1]));
    return float4(color.rgb, 1.0);
}
