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
    var prevTime: Double = 0.00
    
    
    required init() {
        self.levels = [LevelProtocol]()
        self.currentLevel = 0
    }
    
    func load() {
        let level = LevelOne()
        level.load()
        levels.append(level)
        prevTime = Date.now.timeIntervalSince1970
    }
    
    func update() {
        let dt = calculateDeltaTime()
        
        #if DEBUG
        print("Delta Time: \(dt)")
        #endif
        
        handleInput()
        levels[currentLevel].update(dt: dt)
        
        if levels[currentLevel].gameOver {
            print ("GAME OVER")
        }
    }
    
    private func calculateDeltaTime() -> Double {
        let currentSeconds = Date.now.timeIntervalSince1970
        let dt = currentSeconds - prevTime
        prevTime = currentSeconds
        return 1 / dt / 1000
    }
    
    private func handleInput() {        
        guard var playerNode = levels[currentLevel].findGameObject(name: "player") else {
            fatalError("Error in handleInput: could not find player")
        }
        
        if (Keyboard.isKeyPressed(.rightArrow)) {
            if playerNode.position.x < 6 {
                playerNode.position.x += 0.01
            }
        }
        
        if (Keyboard.isKeyPressed(.leftArrow)) {
            if playerNode.position.x > -6 {
                playerNode.position.x -= 0.01
            }
        }
        
        if (Keyboard.isKeyPressed(.space) && levels[currentLevel].findGameObject(name: "playerBullet") == nil) {
            let bullet = Bullet(name: "playerBullet", direction: .Up)
            bullet.position.x = playerNode.position.x
            bullet.position.y = playerNode.position.y + 0.25
            levels[currentLevel].addGameObject(bullet)
        }
        
        // testing code
        if (Keyboard.isKeyPressed(.r)) {
            self.levels[currentLevel].load()
        }
    }
    
    func render(encoder: any MTLRenderCommandEncoder) {
        levels[currentLevel].render(renderEncoder: encoder)
    }
    
    
}
