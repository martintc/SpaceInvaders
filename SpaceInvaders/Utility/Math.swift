//
//  Math.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/12/24.
//

import simd

func getScaleMatrix(_ vector: simd_float3) -> simd_float4x4 {
    return simd_float4x4(simd_float4(vector.x, 0, 0, 0),
                         simd_float4(0, vector.y, 0, 0),
                         simd_float4(0, 0, vector.z, 0),
                         simd_float4(0, 0, 0, 1))
}

func getTranslationMatrix(_ vector: simd_float3) -> simd_float4x4 {
    return simd_float4x4(simd_float4(1, 0, 0, 0),
                         simd_float4(0, 1, 0, 0),
                         simd_float4(0, 0, 1, 0),
                         simd_float4(vector.x, vector.y, vector.z, 1))
}

func getRotationMatrix(_ vector: simd_float3) -> simd_float4x4 {
    if vector.x == 0 && vector.y == 0 && vector.z == 0 {
        return matrix_identity_float4x4
    }
    
    let angleRadians = Float.pi / 3
    let a = normalize(vector)
    let x = a.x, y = a.y, z = a.z
    let c = cosf(angleRadians)
    let s = sinf(angleRadians)
    let t = 1 - c
    return simd_float4x4(simd_float4( t * x * x + c,     t * x * y + z * s, t * x * z - y * s, 0),
              simd_float4( t * x * y - z * s, t * y * y + c,     t * y * z + x * s, 0),
              simd_float4( t * x * z + y * s, t * y * z - x * s,     t * z * z + c, 0),
              simd_float4(                 0,                 0,                 0, 1))
}
