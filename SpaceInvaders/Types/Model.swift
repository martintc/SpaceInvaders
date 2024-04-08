//
//  Model.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 2/21/24.
//

import Metal

class Model {
    var vertexBuffer: MTLBuffer
    var indexBuffer: MTLBuffer
    
    init(vertexBuffer: MTLBuffer, indexBuffer: MTLBuffer) {
        self.vertexBuffer = vertexBuffer
        self.indexBuffer = indexBuffer
    }
}
