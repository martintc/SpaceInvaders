//
//  LevelOne.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/18/24.
//

import Foundation
import simd
import MetalKit

class LevelOne: LevelProtocol {
    var gameObjects: [any NodeProtocol]
    var camera: Camera
    
    init() {
        gameObjects = [any NodeProtocol]()
        camera = FixedCamera()
        self.camera.position = simd_float3(0, 2, 10);
    }
    
    func load() {
        let playerNode = Player(name: "player")
        playerNode.scale = simd_float3(0.25, 0.25, 0.25)
        playerNode.position = simd_float3(0, -2, 0)
        gameObjects.append(playerNode)
    }
    
    func render(renderEncoder: any MTLRenderCommandEncoder) {
        for gameObject in gameObjects {
            gameObject.render(renderEncoder, camera: self.camera)
        }
    }
    
    func update() {
        for gameObject in gameObjects {
            gameObject.update()
        }
    }
}