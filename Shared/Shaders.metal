//
//  Shaders.metal
//  Bezier3D
//
//  Created by Patryk Edyko on 26/07/2021.
//

#include <metal_stdlib>
using namespace metal;
#import "MVP.h"

struct VertexIn
{
    float4 position [[attribute(0)]];
};

struct VertexOut
{
    float4 position [[position]];
};

vertex VertexOut vertexPosition(const VertexIn in [[stage_in]], constant MVPMatrices& mvp [[buffer(1)]])
{
    return {mvp.projection * mvp.view * mvp.model * in.position};
}

fragment float4 color()
{
    return {0.0, 1.0, 1.0, 1.0};
}
