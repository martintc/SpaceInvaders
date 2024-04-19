//
//  NodeProtocol.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/28/24.
//

import simd
import MetalKit

protocol NodeProtocol {
    var name: String { get set }
    var nodeType: NodeType { get set }
    var position: simd_float3 { get set }
    var scale: simd_float3 { get set }
    var parentNode: NodeProtocol? { get set}
    var children: [NodeProtocol] { get set }
    var modelName: String { get set }
    var textureName: String { get set }
    var isVisible: Bool { get set }
    var primitiveType: MTLPrimitiveType { get set }
    var color: simd_float3 { get set }
    
    init(name: String)
    
    func update()
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder, camera: Camera)
}

extension NodeProtocol {
    var modelMatrix: simd_float4x4 {
        var modelMatrix = matrix_identity_float4x4
        
        modelMatrix.translate(direction: self.position)
        
        modelMatrix.scale(axis: scale)
        
        return modelMatrix
    }
    
    /// Set the position of node
    /// - Parameter position: position of a node
    mutating func setPosition(_ position: simd_float3) {
        self.position = position
    }
    
    /// Set the reference name in the scene model
    /// - Parameter name: reference name
    mutating func setModelName(_ name: String) {
        self.modelName = name
    }
    
    /// Set the reference name in the scene texture
    /// - Parameter name: reference name
    mutating func setTextureName(_ name: String) {
        self.textureName = name
    }
    
    /// Toggle the is visible flag
    mutating func toggleIsVisible() {
        self.isVisible = !self.isVisible
    }
    
    /// Move the position of a node by vector addition
    /// - Parameter movementVector: position which to add the node's current position vector by
    mutating func moveBy(by movementVector: simd_float3) {
        self.position += movementVector
    }

    /// Add a parent node to a node
    /// - Parameter parent: Node to be the parent node
    mutating func addParentNode(parent: NodeProtocol) {
        self.parentNode = parent
    }
    
    /// Add a child node
    /// - Parameter node: Node to be added as a child node
    mutating func addChildNode(_ child: NodeProtocol) {
        self.children.append(child)
    }
    
    /// Recursively search children nodes for a node of a given name
    /// - Parameter name: Name of the node to search for
    /// - Returns: Return the node of a given name if it exists
    func nodeNamedRecursive(_ name: String) -> NodeProtocol? {
        for node in children {
            if node.name == name {
                return node
            } else if let matchingGrandChild = node.nodeNamedRecursive(name) {
                return matchingGrandChild
            }
        }
        
        return nil
    }
    
    func updateRecursive() {
        self.update()
        for node in children {
            node.updateRecursive()
        }
    }
    
    func renderRecursive(_ renderCommandEncoder: MTLRenderCommandEncoder, camera: Camera) {
        self.render(renderCommandEncoder, camera: camera)
        for node in children {
            node.renderRecursive(renderCommandEncoder, camera: camera)
        }
    }
    
    func render(_ renderCommandEncoder: MTLRenderCommandEncoder, camera: Camera) {
        if self.modelName.isEmpty || self.textureName.isEmpty {
            return
        }
        
        guard let model = ModelLibray.shared.getModel(name: self.modelName) else {
            fatalError("Error: model \(self.modelName) was expected to be present for node \(self.name)")
        }
        
        guard let texture = TextureLibrary.shared.getTexture(name: self.textureName) else {
            fatalError("Error: texture \(self.textureName) was expected was expected to be present for node \(self.name).")
        }
        
        var vertexUniforms = VertexUniforms(modelMatrix: self.modelMatrix,
                                            viewMatrix: camera.viewMatrix,
                                            projectionMatrix: camera.projectionMatrix)
        
        renderCommandEncoder.setVertexBytes(&vertexUniforms,
                                     length: MemoryLayout<VertexUniforms>.size,
                                     index: 1)
        
        renderCommandEncoder.setVertexBuffer(model.vertexBuffer,
                                      offset: 0,
                                      index: 30)
        
        renderCommandEncoder.setFragmentTexture(texture,
                                         index: 0)
        
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle,
                                            indexCount: model.indexBuffer.length / MemoryLayout<UInt16>.size,
                                            indexType: .uint16,
                                            indexBuffer: model.indexBuffer,
                                            indexBufferOffset: 0)
    }
}
