//
//  TextureLibrary.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/7/24.
//

import Foundation
import Metal
import MetalKit

class TextureLibrary {
    static let shared = TextureLibrary()
    
    private var textureLoader: MTKTextureLoader
    private var library: [String: MTLTexture]
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error: Unable to create default device in TextureLoader")
        }
        
        textureLoader = MTKTextureLoader(device: device)
        library = [String: MTLTexture]()
    }
    
    func loadTextures() {
        do {
            let playerTexture = try textureLoader.newTexture(name: "player",
                                                    scaleFactor: 1.0,
                                                    bundle: Bundle.main,
                                                    options: [MTKTextureLoader.Option.textureStorageMode : 0])
            
            let alienTexture = try textureLoader.newTexture(name: "yellow",
                                                        scaleFactor: 1.0,
                                                        bundle: Bundle.main,
                                                        options: [MTKTextureLoader.Option.textureStorageMode : 0])
            
            self.storeTexture(name: "player", texture: playerTexture)
            self.storeTexture(name: "alien", texture: alienTexture)
        } catch {
            fatalError("Error in TextureLibrary: Issue loading textures")
        }
    }
    
    private func storeTexture(name: String, texture: MTLTexture) {
        self.library[name] = texture
    }
    
    func getTexture(name: String) -> MTLTexture? {
        return self.library[name]
    }
    
}
