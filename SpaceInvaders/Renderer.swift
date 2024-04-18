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

class Renderer: NSObject, MTKViewDelegate {

    public let device: MTLDevice
    var view: MTKView
    var renderPipelineState: MTLRenderPipelineState
    var commandQueque: MTLCommandQueue
    var vertexDescriptor: MTLVertexDescriptor
    
    var scene: SceneOne
    
    var level: LevelProtocol

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
        
        self.level = LevelOne()
        self.level.load()
        
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
//        self.scene.update()
        self.level.update()
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
        
//        self.scene.render(renderCommandEncoder: renderEncoder, camera: self.scene.camera)
        
        self.level.render(renderEncoder: renderEncoder)
        
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        /// Respond to drawable size or orientation changes here

//        let aspect = Float(size.width) / Float(size.height)
//        projectionMatrix = matrix_perspective_right_hand(fovyRadians: radians_from_degrees(65), aspectRatio:aspect, nearZ: 0.1, farZ: 100.0)
    }
}
