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
    
    required init(name: String) {
        self.name = name
        self.parentNode = nil
        self.children = [NodeProtocol]()
    }
    
    func update() {
        // do nothing
    }
    
}
