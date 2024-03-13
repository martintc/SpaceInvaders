//
//  Vertex.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/12/24.
//

import simd

struct Vertex {
    var position: simd_float3 // (float, float float) (1.0, 1.0, 1.0) (x, y, z)
    var texCoord: simd_float3 // (r, b, g)
}
