//
//  Alien.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/28/24.
//

import Foundation
import simd
import MetalKit

class Alien: NodeProtocol {
    var parentNode: (any NodeProtocol)?
    
    var children: [any NodeProtocol]
    
    var nodeType: NodeType = NodeType.Sprite
    
    var name: String
    
    var position: simd_float3 = simd_float3(0, 0, 0)
    
    var scale: simd_float3 = simd_float3(1, 1, 1)
    
    var modelName: String = "quad"
    
    var textureName: String = "alien"
    
    var isVisible: Bool = true
    
    var primitiveType: MTLPrimitiveType = .triangle
    
    var color: simd_float3 = simd_float3(0, 0, 0)
    
    var collidable: Bool = true
    
    var isProjectile: Bool = false
    
    var isDead: Bool
    
    required init(name: String) {
        self.name = name
        self.parentNode = nil
        self.children = [NodeProtocol]()
        self.color = simd_float3(0, 0, 0)
        self.isDead = false
    }
    
    func update() {
        // do nothing
    }
    
}
