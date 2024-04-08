//
//  SceneOne.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 2/21/24.
//

import Foundation
import Metal
import simd
import MetalKit

class SceneOne: Scene {
    
    init(device: MTLDevice) {
        super.init()
        
        // Create a player node
        let playerNode = Player(name: "player")
        playerNode.scale = simd_float3(0.25, 0.25, 0.25)
        playerNode.position = simd_float3(0, -2, 0)
        self.rootNode.addChildNode(playerNode)
        
        var alienNodes = GenericNode(name: "aliens")
        
        // alien 1
        let alienNode = Alien(name: "alien")
        alienNode.scale = simd_float3(0.25, 0.25, 0.25)
        alienNodes.addChildNode(alienNode)
        
        self.rootNode.addChildNode(alienNodes)
        
//        let aliens = Node(name: "aliens")
//        
//        // create an alien node
//        let alienNode = Node(name: "alien")
//        alienNode.position = simd_float3(0, 0, 0)
//        alienNode.setModelName("quad")
//        alienNode.setTextureName("alien")
//        alienNode.scale = simd_float3(0.25, 0.25, 0.25)
//        aliens.addChildNode(child: alienNode)
//        
//        let alienNodeTwo = Node(name: "alien")
//        alienNodeTwo.position = simd_float3(0.30, 0, 0)
//        alienNodeTwo.setModelName("quad")
//        alienNodeTwo.setTextureName("alien")
//        alienNodeTwo.scale = simd_float3(0.25, 0.25, 0.25)
//        aliens.addChildNode(child: alienNodeTwo)
//        
//        let alienNodeThree = Node(name: "alien")
//        alienNodeThree.position = simd_float3(0, 0.30, 0)
//        alienNodeThree.setModelName("quad")
//        alienNodeThree.setTextureName("alien")
//        alienNodeThree.scale = simd_float3(0.25, 0.25, 0.25)
//        aliens.addChildNode(child: alienNodeThree)
        
        // Add player node to scene
//        self.rootNode.addChildNode(child: playerNode)
//        self.rootNode.addChildNode(child: aliens)
        
        // configure camera
        self.camera.position = simd_float3(0, 2, 10);
    }
    
}
