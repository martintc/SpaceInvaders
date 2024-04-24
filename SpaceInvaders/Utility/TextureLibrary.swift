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
    
    func loadTexture(sourceName: String, textureName: String) {
        do {
            let playerTexture = try textureLoader.newTexture(name: sourceName,
                                                    scaleFactor: 1.0,
                                                    bundle: Bundle.main,
                                                    options: [MTKTextureLoader.Option.textureStorageMode : 0])
            
            self.storeTexture(name: textureName, texture: playerTexture)
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
    
//    func loadSpriteSheet(textureName: String,
//                         spriteNames: [String],
//                         rows: Int,
//                         columns: Int) {
//        
//        if (rows * columns) != spriteNames.count {
//            fatalError("Error in TextureLibrary: Not enough sprite names for expected sprites")
//        }
//        
//        do {
//            let totalImages = rows * columns
//            let texture = try textureLoader.newTexture(name: textureName,
//                                                       scaleFactor: 1.0,
//                                                       bundle: Bundle.main,
//                                                       options: [MTKTextureLoader.Option.textureStorageMode : 0])
//            let textureHeight = CGFloat(texture.height)
//            let textureWidth = CGFloat(texture.width)
//            
//            let spriteWidth: CGFloat = textureWidth / CGFloat(columns)
//            let spriteHeight: CGFloat = textureHeight / CGFloat(rows)
//            
//            for row in 0..<rows {
//                for column in 0..<columns {
//                    let spriteRect = CGRect(x: CGFloat(column) * spriteWidth,
//                                            y: CGFloat(row) * spriteHeight,
//                                            width: CGFloat(spriteWidth),
//                                            height: CGFloat(spriteHeight))
//                    if let spriteTexture = textureLoader.makeTextureView(pixelFormat: texture.pixelFormat,
//                                                                   textureType: .type2D,
//                                                                   levels: 0..<1,
//                                                                   slices: 0..<1,
//                                                                   region: spriteRect) {
//                        
//                    }
//                }
//            }
//            
//        } catch {
//            fatalError("Error in TextureLibrary: Issue loading sprite sheet")
//        }
//    }
    
}
