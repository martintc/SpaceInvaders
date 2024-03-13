//
//  simd_float3+Extension.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/12/24.
//

import simd

extension simd_float3 {
    func normalize() -> simd_float3 {
        let x = self.x * self.x
        let y = self.y * self.y
        let z = self.z * self.z
        let magnitude = sqrtf(x + y + z)
        return self / magnitude
    }
    
    static func normalize(vector a: simd_float3) -> simd_float3 {
        let x = a.x * a.x
        let y = a.y * a.y
        let z = a.z * a.z
        let magnitude = sqrtf(x + y + z)
        return a / magnitude
    }
    
    static func crossProduct(a: simd_float3, b: simd_float3) -> simd_float3 {
        var c = simd_float3()
        c.x = (a.y * b.z) - (a.z * b.y)
        c.y = (a.z * b.x) - (b.z * a.x)
        c.z = (a.x * b.y) - (b.z * a.y)
        return c
    }
    
    static func dotProduct(a: simd_float3, b: simd_float3) -> Float {
        (a.x * b.x) + (a.y * b.y) + (a.z * b.z)
    }
}
