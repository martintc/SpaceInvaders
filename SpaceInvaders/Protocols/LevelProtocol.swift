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
    
    mutating func update() {
        for gameObject in gameObjects {
            gameObject.updateRecursive()
        }
        checkBulletBounds()
        checkCollisions()
    }
    
    private mutating func checkBulletBounds() {
        guard let bullet = self.findGameObject(name: "playerBullet") else {
            return
        }
        
        if bullet.position.y > 10 {
            gameObjects.removeLast()
            print("Removed")
        }
    }
    
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
                
                if projectile.position.x < collidable.position.x + 0.25 && projectile.position.x > collidable.position.x - 0.25 {
                    if projectile.position.y < collidable.position.y + 0.25 && projectile.position.y > collidable.position.y - 0.25 {
                        markForDead.append(i)
                        markForDead.append(j)
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
