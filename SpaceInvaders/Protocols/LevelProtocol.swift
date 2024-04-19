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
            
            var childObject = gameObject.nodeNamedRecursive(name)
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
    
    mutating func addGameObject(_ node: any NodeProtocol) {
        self.gameObjects.append(node)
    }
}
