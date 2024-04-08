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
    
    func render()
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
    
    func renderRecursive() {
        self.render()
        for node in children {
            node.renderRecursive()
        }
    }
}
