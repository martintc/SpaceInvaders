//
//  Player.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/28/24.
//

import Foundation
import simd
import MetalKit

class Player: NodeProtocol {
    var color: simd_float3
    
    var name: String
    
    var nodeType: NodeType = NodeType.Sprite
    
    var position: simd_float3 = simd_float3(0, 0, 0)
    
    var scale: simd_float3 = simd_float3(1, 1, 1)
    
    var parentNode: NodeProtocol?
    
    var children: [NodeProtocol]
    
    var modelName: String = "quad"
    
    var textureName: String = "player"
    
    var isVisible: Bool = true
    
    var primitiveType: MTLPrimitiveType = .triangle
    
    var cannonActive = false
    
    var collidable: Bool = true
    
    var isProjectile: Bool = false
    
    var isDead: Bool
    
    var layer: Int8
    
    var mask: Int8
    
    required init(name: String) {
        self.name = name
        self.children = [NodeProtocol]()
        self.parentNode = nil
        self.color = simd_float3(0, 0, 0)
        self.isDead = false
        self.layer = 1
        self.mask = 0 
    }
    
    func update() {
//        if (Keyboard.isKeyPressed(.rightArrow)) {
//            self.position.x += 0.01
//        }
//        
//        if (Keyboard.isKeyPressed(.leftArrow)) {
//            self.position.x -= 0.01
//        }
//        
//        if (Keyboard.isKeyPressed(.space) && cannonActive == false) {
//            let bullet = Bullet(name: "bullet", direction: .Up)
//            let parent = self
//            bullet.parentNode = parent
//            self.children.append(bullet)
//            cannonActive = true
//        }
    }
    
    
}
