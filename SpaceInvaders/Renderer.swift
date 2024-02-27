//
//  Renderer.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 2/16/24.
//

// Our platform independent renderer class

import Metal
import MetalKit
import simd

struct Vertex {
    var position: simd_float3 // (float, float float) (1.0, 1.0, 1.0) (x, y, z)
    var texCoord: simd_float3 // (r, b, g)
}

struct VertexUniforms {
    var viewProjectionMatrix: simd_float4x4
    var modelMatrix: simd_float4x4
}

class Renderer: NSObject, MTKViewDelegate {

    public let device: MTLDevice
    var view: MTKView
    var renderPipelineState: MTLRenderPipelineState
    var commandQueque: MTLCommandQueue
    var vertexDescriptor: MTLVertexDescriptor
    
    var scene: SceneOne

    init?(metalKitView: MTKView) {
        self.view = metalKitView
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error: Unable to create a default device")
        }
        
        self.device = device
        
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Error: unable to make command queue")
        }
        
        self.commandQueque = commandQueue
        
        self.vertexDescriptor = Renderer.buildVertexDescriptor()
        
        self.renderPipelineState = Renderer.buildRenderPipelineState(self.view, device: self.device, vertexDescriptor: self.vertexDescriptor)
        
        self.scene = SceneOne(device: self.device)
        
        super.init()
    }
    
    static func buildVertexDescriptor() -> MTLVertexDescriptor {
        let vertexDescriptor: MTLVertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.layouts[30].stride = MemoryLayout<Vertex>.size
        vertexDescriptor.layouts[30].stepRate = 1
        vertexDescriptor.layouts[30].stepFunction = .perVertex
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 30
        vertexDescriptor.attributes[0].offset = MemoryLayout.offset(of: \Vertex.position)!
        
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].bufferIndex = 30
        vertexDescriptor.attributes[1].offset = MemoryLayout.offset(of: \Vertex.texCoord)!
        
        return vertexDescriptor
    }
    
    static func buildRenderPipelineState(_ view: MTKView, device: MTLDevice, vertexDescriptor: MTLVertexDescriptor) -> MTLRenderPipelineState {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Error: could not make default library")
        }
        
        renderPipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        renderPipelineDescriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
        
        do {
            return try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            fatalError("Error: \(error)")
        }
    }
    
    func update() {
        let projectionMatrix = matrix_perspective_right_hand(fovyRadians: .pi / 6,
                                                                      aspectRatio: getAspectRatio(view: self.view),
                                                                      nearZ: 0.1,
                                                                      farZ: 100)
        let viewMatrix = self.scene.camera.getModelMatrix()
        
        self.scene.camera.modelMatrix = projectionMatrix * viewMatrix
    }

    func draw(in view: MTKView) {
        update()
        
        guard let drawable = self.view.currentDrawable else {
            fatalError("Error: could not get drawable")
        }
        
        guard let commandBuffer = self.commandQueque.makeCommandBuffer() else {
            fatalError("Error: could not get the command buffer")
        }
        
        guard let renderPassDecriptor = self.view.currentRenderPassDescriptor else {
            fatalError("Error: could not get render pass Descriptor")
        }
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDecriptor) else {
            fatalError("Error: could not get render encoder")
        }
        
        renderEncoder.setRenderPipelineState(self.renderPipelineState)
        
        drawScene(renderEncoder: renderEncoder)
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func drawScene(renderEncoder: MTLRenderCommandEncoder) {
        drawNodeRecursive(self.scene.rootNode, renderEncoder: renderEncoder, models: scene.models, textures: scene.textures, camera: self.scene.camera)
    }
    
    func drawNodeRecursive(_ node: Node, renderEncoder: MTLRenderCommandEncoder, models: [String: Model], textures: [String: MTLTexture], camera: Node) {
        if node.isVisible && !node.modelName.isEmpty && !node.textureName.isEmpty {
            guard let model = models[node.modelName] else {
                fatalError("Error: model \(node.modelName) was expected to be present.")
            }
            
            guard let texture = textures[node.textureName] else {
                fatalError("Error: texture \(node.textureName) was expected was expected to be present.")
            }
            
            var vertexUniforms = VertexUniforms(viewProjectionMatrix: self.scene.camera.modelMatrix,
                                               modelMatrix: node.getModelMatrix())
            
            renderEncoder.setVertexBytes(&vertexUniforms,
                                         length: MemoryLayout<VertexUniforms>.size,
                                         index: 1)
            
            renderEncoder.setVertexBuffer(model.vertexBuffer,
                                          offset: 0,
                                          index: 30)
            
            renderEncoder.setFragmentTexture(texture,
                                             index: 0)
            
            renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: model.indexBuffer.length / MemoryLayout<UInt16>.size,
                                                indexType: .uint16,
                                                indexBuffer: model.indexBuffer,
                                                indexBufferOffset: 0)
        }
        
        for child in node.children {
            drawNodeRecursive(child,
                              renderEncoder: renderEncoder,
                              models: models,
                              textures: textures,
                              camera: camera)
        }
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        /// Respond to drawable size or orientation changes here

//        let aspect = Float(size.width) / Float(size.height)
//        projectionMatrix = matrix_perspective_right_hand(fovyRadians: radians_from_degrees(65), aspectRatio:aspect, nearZ: 0.1, farZ: 100.0)
    }
}
