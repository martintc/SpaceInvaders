//
//  GenericNode.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/29/24.
//

import Foundation
import simd
import MetalKit

class GenericNode: NodeProtocol {
    var parentNode: (any NodeProtocol)?
    
    var children: [any NodeProtocol]
    
    var nodeType: NodeType = NodeType.None
    
    var name: String
    
    var position: simd_float3 = simd_float3(0, 0, 0)
    
    var scale: simd_float3 = simd_float3(0, 0, 0)
    
    var modelName: String = ""
    
    var textureName: String = ""
    
    var isVisible: Bool = false
    
    var primitiveType: MTLPrimitiveType = .triangle
    
    var color: simd_float3 = simd_float3(0, 0, 0)
    
    var collidable: Bool = false
    
    var isProjectile: Bool = false
    
    var isDead: Bool
    
    var layer: Int8
    
    var mask: Int8
    
    required init(name: String) {
        self.name = name
        self.parentNode = nil
        self.children = [NodeProtocol]()
        self.isDead = false
        self.layer = 0
        self.mask = 0
    }
    
    func update() {
        // do nothing
    }
    
}
