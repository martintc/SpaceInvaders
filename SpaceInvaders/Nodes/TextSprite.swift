//
//  TextSprite.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/23/24.
//

import Foundation
import MetalKit
import simd

class TextSprite: NodeProtocol {
    var name: String
    
    var nodeType: NodeType = .Sprite
    
    var position: simd_float3 = simd_float3(0, 0, 0)
    
    var scale: simd_float3 = simd_float3(0.25, 0.25, 0)
    
    var parentNode: (any NodeProtocol)? = nil
    
    var children: [any NodeProtocol]
    
    var modelName: String = "quad"
    
    var textureName: String
    
    var isVisible: Bool
    
    var primitiveType: MTLPrimitiveType = .triangle
    
    var color: simd_float3 = simd_float3(0, 0, 0)
    
    var collidable: Bool = false
    
    var isProjectile: Bool = false
    
    var isDead: Bool = false
    
    required init(name: String) {
        self.name = name
        self.textureName = name
        isVisible = true
        self.children = [NodeProtocol]()
    }
    
    func update() {
        // do nothing
    }
    
    
}
