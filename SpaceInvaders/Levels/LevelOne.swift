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
    var alienMoveDirection: Direction
    var gameOver: Bool
    
    init() {
        gameObjects = [any NodeProtocol]()
        camera = FixedCamera()
        self.camera.position = simd_float3(0, 5, 15);
        alienMoveDirection = .Right
        gameOver = false
    }
    
    func load() {
        if gameObjects.count > 0 {
            gameObjects.removeAll()
        }
        
        let universalScale = simd_float3(0.40, 0.40, 0.40)
        
        let playerNode = Player(name: "player")
        playerNode.scale = universalScale
        playerNode.position = simd_float3(0, 0, 0)
        
        var aliens = [Alien]()
        
        var alienPosition = simd_float3(-5, 8, 0)
        let changeX = simd_float3(0.5, 0, 0)
        let changeY = simd_float3(0, 0.5, 0)
        
        for i in 1...55 {
            let alien = Alien(name: "alien")
            alien.position = alienPosition
            alien.scale = universalScale
            
            aliens.append(alien)
        
            alienPosition += changeX
            
            if i % 11 == 0 {
                alienPosition -= changeY
                alienPosition.x = -5
            }
        }
        
        let spaceInvadersText = getRenderedText(text: "space invaders", startingPosition: simd_float3(-2, 10, 0), scale: universalScale, spacing: 0.35)
        
        gameObjects.append(playerNode)
        gameObjects.append(contentsOf: aliens)
        gameObjects.append(spaceInvadersText)
        
    }
}
