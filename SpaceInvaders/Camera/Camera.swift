//
//  Camera.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/12/24.
//

import simd

protocol Camera {
    var cameraType: CameraType { get }
    var position: simd_float3 { get set }
    var rotation: simd_float3 { get set }
    var projectionMatrix: simd_float4x4 { get }
    
    func update(deltaTime: Float)
}

extension Camera {
    var viewMatrix: simd_float4x4 {
        var viewMatrix = matrix_identity_float4x4

        if self.rotation.x != 0 {
            viewMatrix.rotate(angle: self.rotation.x, axis: X_AXIS)
        }
        
        if self.rotation.y != 0 {
            viewMatrix.rotate(angle: self.rotation.y, axis: Y_AXIS)
        }
        
        if self.rotation.z != 0 {
            viewMatrix.rotate(angle: self.rotation.z, axis: Z_AXIS)
        }
        
        viewMatrix.translate(direction: -position)
        
        return viewMatrix
    }
}


