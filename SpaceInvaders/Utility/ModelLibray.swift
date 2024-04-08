//
//  ModelLibray.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/7/24.
//

import Foundation
import Metal
import MetalKit

class ModelLibray {
    static let shared = ModelLibray()
    
    private var device: MTLDevice
    private var library: [String: Model]
    
    init() {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error: Unable to create default device in TextureLoader")
        }
        
        self.device = device
        self.library = [String: Model]()
    }
    
    func loadModels() {
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
        
        guard let quadVertexBuffer = device.makeBuffer(bytes: verticies,
                                                       length: MemoryLayout.stride(ofValue: verticies[0]) * verticies.count,
                                                       options: MTLResourceOptions.storageModeShared) else {
            fatalError("Error in ModelLibrary: could not load quad vertex buffer")
        }
        
        guard let quadIndexBuffer = device.makeBuffer(bytes: indicies,
                                                      length: MemoryLayout.stride(ofValue: indicies[0]) * indicies.count,
                                                      options: MTLResourceOptions.storageModeShared) else {
            fatalError("Error in ModelLibrary: could not load quad index buffer")
        }
        
        let model = Model(vertexBuffer: quadVertexBuffer, indexBuffer: quadIndexBuffer)
        self.storeModel(name: "quad", model: model)
        
    }
    
    private func storeModel(name: String, model: Model) {
        self.library[name] = model
    }
    
    func getModel(name: String) -> Model? {
        return self.library[name]
    }
    
}
