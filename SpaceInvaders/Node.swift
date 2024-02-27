//
//  Node.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 2/21/24.
//

import Foundation
import simd
import Metal

class Node {
    var name: String
    var position: simd_float3 = simd_float3(0, 0, 0)
    var parentNode: Node?
    var children = [Node]()
    var modelName: String = ""
    var textureName: String = ""
    var isVisible: Bool = true
    var modelMatrix = matrix_identity_float4x4
    var scale: Float = 1
    var primitiveType: MTLPrimitiveType = MTLPrimitiveType.triangle
    var color: simd_float3 = simd_float3(1, 0, 0)
    
    /// - Parameter name: name of the node
    init(name: String) {
        self.name = name
    }
    
    /// Set the position of node
    /// - Parameter position: position of a node
    func setPosition(_ position: simd_float3) {
        self.position = position
    }
    
    /// Set the reference name in the scene model
    /// - Parameter name: reference name
    func setModelName(_ name: String) {
        self.modelName = name
    }
    
    /// Set the reference name in the scene texture
    /// - Parameter name: reference name
    func setTextureName(_ name: String) {
        self.textureName = name
    }
    
    /// Toggle the is visible flag
    func toggleIsVisible() {
        self.isVisible = !self.isVisible
    }
    
    /// Move the position of a node by vector addition
    /// - Parameter movementVector: position which to add the node's current position vector by
    func moveBy(by movementVector: simd_float3) {
        self.position += movementVector
    }

    /// Add a parent node to a node
    /// - Parameter parent: Node to be the parent node
    func addParentNode(parent: Node) {
        self.parentNode = parent
    }
    
    /// Add a child node
    /// - Parameter node: Node to be added as a child node
    func addChildNode(child: Node) {
        self.children.append(child)
    }
    
    /// Get the model matrix
    /// - Returns: Model matrix which is a combination of the position, and scale
    func getModelMatrix() -> simd_float4x4 {
        let scaleMatrix = simd_float4x4(scaleBy: self.scale)
        let translationMatrix = simd_float4x4(self.position[0], self.position[1], self.position[2])
        return translationMatrix * scaleMatrix
    }
    
    /// Recursively search children nodes for a node of a given name
    /// - Parameter name: Name of the node to search for
    /// - Returns: Return the node of a given name if it exists
    func nodeNamedRecursive(_ name: String) -> Node? {
        for node in children {
            if node.name == name {
                return node
            } else if let matchingGrandChild = node.nodeNamedRecursive(name) {
                return matchingGrandChild
            }
        }
        
        return nil
    }
}
