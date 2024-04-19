//
//  Game.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/18/24.
//

import Foundation
import MetalKit

class Game: GameProtocol {
    var levels: [any LevelProtocol]
    var currentLevel: Int
    
    required init() {
        self.levels = [LevelProtocol]()
        self.currentLevel = 0
    }
    
    func load() {
        let level = LevelOne()
        level.load()
        levels.append(level)
    }
    
    func update() {
        handleInput()
        levels[currentLevel].update()
    }
    
    private func handleInput() {        
        var playerNode = levels[currentLevel].findGameObject(name: "player")
        if playerNode == nil {
            fatalError("Error in input handling")
        }
        
        if (Keyboard.isKeyPressed(.rightArrow)) {
            playerNode?.position.x += 0.01
        }
        
        if (Keyboard.isKeyPressed(.leftArrow)) {
            playerNode?.position.x -= 0.01
        }
        
        if (Keyboard.isKeyPressed(.space) && levels[currentLevel].findGameObject(name: "playerBullet") == nil) {
            let bullet = Bullet(name: "playerBullet", direction: .Up)
            bullet.position.x = playerNode!.position.x
            bullet.position.y = playerNode!.position.y
            levels[currentLevel].addGameObject(bullet)
        }
    }
    
    func render(encoder: any MTLRenderCommandEncoder) {
        levels[currentLevel].render(renderEncoder: encoder)
    }
    
    
}
