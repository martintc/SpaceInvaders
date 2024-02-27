//
//  Scene.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 2/21/24.
//

import Foundation
import Metal
import MetalKit

class Scene {
    var rootNode = Node(name: "Root")
    var textures = [String : MTLTexture]()
    var models = [String : Model]()
    var camera = Node(name: "Camera")
    
    /// Insert into texture dictionary a new texture
    /// - Parameter name: reference name of the texture
    /// - Parameter texture: MTLTexture to insert
    func addTexture(_ name: String, texture: MTLTexture) {
        textures[name] = texture
    }
    
    /// Insert into model buffer dictionary new vertex buffer
    /// - Parameter name: reference name of the model buffer
    /// - Parameter model: Model to insert
    func addModel(_ name: String, model: Model) {
        models[name] = model
    }
    
    /// Return the texture of the given name
    /// - Parameter name: name of texture to query for
    /// - Returns: MTLTexture if found
    func textureNamed(_ name: String) -> MTLTexture? {
        return textures[name]
    }
    
    /// Return the model buffer of the given name
    /// - Parameter name: name of the model buffer to query for
    /// - Returns: Model if found
    func modelNamed(_ name: String) -> Model? {
        return models[name]
    }
    
    /// Returns the node of a given name
    /// - Parameter name: name of the node to query for
    /// - Returns: Node if found
    func nodeName(_ name: String) -> Node? {
        if rootNode.name == name {
            return rootNode
        } else {
            return rootNode.nodeNamedRecursive(name)
        }
    }
    
}
