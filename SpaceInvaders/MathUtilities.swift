//
//  MathUtilities.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 2/26/24.
//

import Foundation
import simd
import MetalKit

// Generic matrix math utility functions
func matrix4x4_rotation(radians: Float, axis: SIMD3<Float>) -> matrix_float4x4 {
    let unitAxis = normalize(axis)
    let ct = cosf(radians)
    let st = sinf(radians)
    let ci = 1 - ct
    let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
    return matrix_float4x4.init(columns:(vector_float4(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0),
                                         vector_float4(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0),
                                         vector_float4(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0),
                                         vector_float4(                  0,                   0,                   0, 1)))
}

func matrix4x4_translation(_ translationX: Float, _ translationY: Float, _ translationZ: Float) -> matrix_float4x4 {
    return matrix_float4x4.init(columns:(vector_float4(1, 0, 0, 0),
                                         vector_float4(0, 1, 0, 0),
                                         vector_float4(0, 0, 1, 0),
                                         vector_float4(translationX, translationY, translationZ, 1)))
}

func matrix_perspective_right_hand(fovyRadians fovy: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
    let ys = 1 / tanf(fovy * 0.5)
    let xs = ys / aspectRatio
    let zs = farZ / (nearZ - farZ)
    return matrix_float4x4.init(columns:(vector_float4(xs,  0, 0,   0),
                                         vector_float4( 0, ys, 0,   0),
                                         vector_float4( 0,  0, zs, -1),
                                         vector_float4( 0,  0, zs * nearZ, 0)))
}

func radians_from_degrees(_ degrees: Float) -> Float {
    return (degrees / 180) * .pi
}

func getAspectRatio(view: MTKView) -> Float {
    return Float(view.drawableSize.width / view.drawableSize.height)
}

func matrix4x4_scale(original matrix: simd_float4x4, scaleBy s: Float) -> simd_float4x4 {
    let scaleMatrix = simd_float4x4(simd_float4(s, 0, 0, 0), simd_float4(0, s, 0, 0), simd_float4(0, 0, s, 1), simd_float4(0, 0, 0, 1))
    return matrix * scaleMatrix
}

extension simd_float4x4 {
    init(scaleBy s: Float) {
        self.init(simd_float4(s, 0, 0, 0), 
                  simd_float4(0, s, 0, 0),
                  simd_float4(0, 0, s, 1),
                  simd_float4(0, 0, 0, 1))
    }
    
    init(_ translationX: Float, _ translationY: Float, _ translationZ: Float) {
        self.init(simd_float4(1, 0, 0, 0),
                  simd_float4(0, 1, 0, 0),
                  simd_float4(0, 0, 1, 0),
                  simd_float4(translationX, translationY, translationZ, 1))
    }
}
