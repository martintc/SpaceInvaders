//
//  LevelProtocol.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/18/24.
//

import MetalKit

protocol LevelProtocol {
    var gameObjects: [NodeProtocol] { get set }
    var camera: Camera { get set }
    var alienMoveDirection: Direction { get set }
    var gameOver: Bool { get set }
    var won: Bool { get set }
    
    var prevShootTimer: Double { get set }
    
    func load()
}

extension LevelProtocol {
    func findGameObject(name: String) -> NodeProtocol? {
        for gameObject in self.gameObjects {
            if gameObject.name == name {
                return gameObject
            }
            
            let childObject = gameObject.nodeNamedRecursive(name)
            if childObject != nil {
                return childObject
            }
        }
        
        return nil
    }
    
    func render(renderEncoder: any MTLRenderCommandEncoder) {
        for gameObject in gameObjects {
            gameObject.renderRecursive(renderEncoder, camera: self.camera)
        }
    }
    
    mutating func update(dt: Double) {
        checkWinCondition()
        
        if won {
            return
        }
        
        for gameObject in gameObjects {
            gameObject.updateRecursive()
        }
        
        let alienBox = getAlienBox()
        let alienMoveVector = getAlienMoveVector(alienBox: alienBox, dt: dt)
        moveAliens(by: alienMoveVector)
        
        checkPlayerCollisions()
        checkBulletBounds()
        checkCollisions()
        
        alienShoot()
    }
    
    private mutating func checkWinCondition() {
        won = gameObjects.filter({ $0.name == "alien" }).count == 0
    }
    
    private func chooseShootingAlien() -> simd_float3 {
        let aliens = gameObjects.filter({ $0.name == "alien" })
        
        let rand = Int.random(in: 0..<aliens.count)
        
        return aliens[rand].position
    }
    
    private mutating func alienShootTimer() -> Bool {
        if prevShootTimer == 0 {
            prevShootTimer = Date.now.timeIntervalSince1970
            return false
        }
        
        let currentTime = Date.now.timeIntervalSince1970
        
        let dt = currentTime - prevShootTimer
        
        let time = dt
        
        if time < 1 {
            return false
        }
        
        prevShootTimer = currentTime
        return true
        
    }
    
    private mutating func alienShoot() {
        if !alienShootTimer() {
            return
        }
        
        // pick and alien
        let alienPosition = chooseShootingAlien()
        
        var bulletPosition = alienPosition
        bulletPosition.y -= 0.25
        
        // create a bullet node
        let alienBullet = Bullet(name: "bullet")
        alienBullet.layer = 2
        alienBullet.mask = 1
        alienBullet.direction = .Down
        alienBullet.position = bulletPosition
        
        // add bullet node to gameObjects
        self.gameObjects.append(alienBullet)
    }
    
    private mutating func getAlienMoveVector(alienBox: Box, dt: Double) -> simd_float3 {
        var xAxis: Float = 0
        var yAxis: Float = 0
        
        if alienBox.x_1 > 6 {
            alienMoveDirection = .Left
            yAxis = -0.5
        }
        
        if alienBox.x_0 < -6.0 {
            alienMoveDirection = .Right
            yAxis = -0.5
        }
        
        if alienMoveDirection == .Right {
            xAxis = 0.1 * Float(dt)
        }
        
        if alienMoveDirection == .Left {
            xAxis = -0.1 * Float(dt)
        }
        
        return simd_float3(xAxis, yAxis, 0)
    }
    
    private mutating func moveAliens(by vector: simd_float3) {
        for var alien in self.gameObjects.filter({ $0.name == "alien" }) {
            alien.moveBy(by: vector)
        }
    }
    
    private func getAlienBox() -> Box {
        var alienBox: Box = Box(x_0: 20,
                                y_0: -20,
                                x_1: -20,
                                y_1: 20)
        
        for alien in gameObjects.filter({ $0.name == "alien" && $0.isDead == false }) {
            if alien.position.x < alienBox.x_0 {
                alienBox.x_0 = alien.position.x
            }
            
            if alien.position.x > alienBox.x_1 {
                alienBox.x_1 = alien.position.x
            }
            
            if alien.position.y > alienBox.y_0 {
                alienBox.y_0 = alien.position.y
            }
            
            if alien.position.y < alienBox.y_1 {
                alienBox.y_1 = alien.position.y
            }
        }
        
        #if DEBUG
        print("Alien Box:")
        print("\tStart: {\(alienBox.x_0), \(alienBox.y_0)}")
        print("\tEnd: {\(alienBox.x_1), \(alienBox.y_1)}")
        #endif
        
        return alienBox
    }
    
    private mutating func checkBulletBounds() {
        var removalList = [Int]()
        
        for (i, object) in gameObjects.enumerated() {
            if object.isProjectile == false {
                continue
            }
            
            if object.position.y > 10 || object.position.y < -1 {
                removalList.append(i)
            }
        }
        
        #if DEBUG
        print("Removing this many bullets: \(removalList.count)")
        #endif
        
        for i in removalList {
            gameObjects.remove(at: i)
        }
        
    }
    
    /// Check is a player has a collision with an enemy bulelt or an enemy body
    private mutating func checkPlayerCollisions() {
        guard let player = findGameObject(name: "player") else {
                fatalError("Error in checkPlayerCollisions: Could not find player")
        }
        
        for alien in gameObjects.filter( { $0.name == "alien"} ) {
            if player.position.x < alien.position.x + 0.25 && player.position.x > alien.position.x - 0.25 {
                if player.position.y < alien.position.y + 0.25 && player.position.y > alien  .position.y - 0.25 {
                    gameOver = true
                    #if DEBUG
                    print("Player dead")
                    #endif
                    
                }
            }
        }
    }
    
    // check if a player bullet collides with an enemy
    private mutating func checkCollisions() {
        var markForDead = [Int]()
        
        for (i, projectile) in gameObjects.enumerated() {
            if projectile.isProjectile == false {
                continue
            }
            
            for (j, collidable) in gameObjects.enumerated() {
                if collidable.collidable == false {
                    continue
                }
                
                if projectile.mask == collidable.layer {
                    if projectile.position.x < collidable.position.x + 0.25 && projectile.position.x > collidable.position.x - 0.25 {
                        if projectile.position.y < collidable.position.y + 0.25 && projectile.position.y > collidable.position.y - 0.25 {
                            markForDead.append(i)
                            markForDead.append(j)
                            
                            if collidable.name == "player" {
                                self.gameOver = true
                                return
                            }
                            
#if DEBUG
                            print("Bullet made a hit!")
#endif
                        }
                    }
                }
            }
        }
        
        for i in markForDead {
            gameObjects.remove(at: i)
        }
    }
    
    mutating func addGameObject(_ node: any NodeProtocol) {
        self.gameObjects.append(node)
    }
}
