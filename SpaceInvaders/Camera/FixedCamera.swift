//
//  FixedCamera.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/12/24.
//

import simd

class FixedCamera: Camera {
    var cameraType: CameraType = CameraType.Fixed
    
    var position: simd_float3 = simd_float3(0, 0, 0)
    
    var rotation: simd_float3 = simd_float3(0, 0, 0)
    
    private var _projectionMatrix: simd_float4x4 = matrix_identity_float4x4
    var projectionMatrix: simd_float4x4 {
        return _projectionMatrix
    }
    
    init() {
        _projectionMatrix = simd_float4x4.perspective(degreesFov: 60,
                                                      aspectRatio: 1,
                                                      near: 0.1,
                                                      far: 100)
    }
    
    func update(deltaTime: Float) {
        // do nothing
    }
    
    
}
