//
//  Bullet.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/7/24.
//

import Foundation
import simd
import Metal
import MetalKit

class Bullet: NodeProtocol {
    var name: String
    
    var nodeType: NodeType = NodeType.Sprite
    
    var position: simd_float3 = simd_float3(0, 0, 0)
    
    var scale: simd_float3 = simd_float3(0.1, 0.1, 0.1)
    
    var parentNode: (any NodeProtocol)?
    
    var children: [any NodeProtocol]
    
    var modelName: String
    
    var textureName: String
    
    var isVisible: Bool = true
    
    var primitiveType: MTLPrimitiveType = .triangle
    
    var color: simd_float3 = simd_float3(0, 0, 0)
    
    var direction: Direction
    
    required init(name: String) {
        self.name = name
        self.modelName = "quad"
        self.textureName = "player"
        self.children = [NodeProtocol]()
        self.direction = Direction.None
    }
    
    init(name: String, direction: Direction) {
        self.name = name
        self.modelName = "quad"
        self.textureName = "player"
        self.children = [NodeProtocol]()
        self.direction = direction
    }
    
    func update() {
        switch(direction) {
        case Direction.Up:
            self.position.y += 0.1
            break
        case Direction.Down:
            self.position.y -= 0.1
            break
        default:
            break
        }
    }
    
    
}
