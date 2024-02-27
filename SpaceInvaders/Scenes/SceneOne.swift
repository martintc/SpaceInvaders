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
        
        let verticies = [
            Vertex(position: simd_float3(-0.5, -0.5, 0), texCoord: simd_float3(0, 1, 0)),
            Vertex(position: simd_float3(-0.5, 0.5, 0), texCoord: simd_float3(0, 0, 0)),
            Vertex(position: simd_float3(0.5, 0.5, 0), texCoord: simd_float3(1, 0, 0)),
            Vertex(position: simd_float3(0.5, -0.5, 0), texCoord: simd_float3(1, 1, 0))
        ]
        
        let indicies: [ushort] = [
            0, 1, 2,
            2, 3, 0
        ]
        
        let triangleBuffer = device.makeBuffer(bytes: verticies,
                                           length: MemoryLayout.stride(ofValue: verticies[0]) * verticies.count,
                                           options: MTLResourceOptions.storageModeShared)!
        
        let indexBuffer = device.makeBuffer(bytes: indicies,
                                        length: MemoryLayout.stride(ofValue: indicies[0]) * indicies.count,
                                        options: MTLResourceOptions.storageModeShared)!
        
        // Create our model
        let model = Model(vertexBuffer: triangleBuffer,
                          indexBuffer: indexBuffer)
        
        // Create our textures
        
        let textureLoader = MTKTextureLoader(device: device)
        
        var playerTexture: MTLTexture? = nil
        var alienTexture: MTLTexture? = nil
        
        do {
            playerTexture = try textureLoader.newTexture(name: "player",
                                                    scaleFactor: 1.0,
                                                    bundle: Bundle.main,
                                                    options: [MTKTextureLoader.Option.textureStorageMode : 0])
            
            alienTexture = try textureLoader.newTexture(name: "yellow",
                                                        scaleFactor: 1.0,
                                                        bundle: Bundle.main,
                                                        options: [MTKTextureLoader.Option.textureStorageMode : 0])
        } catch {
            fatalError("Error when Loading Texture: \(error)")
        }
        
        // insert models
        self.addModel("quad", model: model)
        
        // insert textures
        guard let playerTexture = playerTexture else {
            fatalError("Error: Could not load player texture")
        }
        
        guard let alienTexture = alienTexture else {
            fatalError("Error: Could not load alien texture")
        }
        
        self.addTexture("player", texture: playerTexture)
        self.addTexture("alien", texture: alienTexture)
        
        // Create a player node
        let playerNode = Node(name: "player")
        playerNode.position = simd_float3(0, -2, 0)
        playerNode.setModelName("quad")
        playerNode.setTextureName("player")
        playerNode.scale = 0.25
        
        let aliens = Node(name: "alients")
        
        // create an alien node
        let alienNode = Node(name: "alien")
        alienNode.position = simd_float3(0, 0, 0)
        alienNode.setModelName("quad")
        alienNode.setTextureName("alien")
        alienNode.scale = 0.25
        aliens.addChildNode(child: alienNode)
        
        let alienNodeTwo = Node(name: "alien")
        alienNodeTwo.position = simd_float3(0.30, 0, 0)
        alienNodeTwo.setModelName("quad")
        alienNodeTwo.setTextureName("alien")
        alienNodeTwo.scale = 0.25
        aliens.addChildNode(child: alienNodeTwo)
        
        let alienNodeThree = Node(name: "alien")
        alienNodeThree.position = simd_float3(0, 0.30, 0)
        alienNodeThree.setModelName("quad")
        alienNodeThree.setTextureName("alien")
        alienNodeThree.scale = 0.25
        aliens.addChildNode(child: alienNodeThree)
        
        // Add player node to scene
        self.rootNode.addChildNode(child: playerNode)
        self.rootNode.addChildNode(child: aliens)
        
        // configure camera
        self.camera.position = simd_float3(0, 0, -10);
    }
    
}
