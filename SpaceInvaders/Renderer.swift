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

class Renderer: NSObject, MTKViewDelegate {

    public let device: MTLDevice
    var view: MTKView
    var renderPipelineState: MTLRenderPipelineState
    var commandQueque: MTLCommandQueue
    var vertexDescriptor: MTLVertexDescriptor
    
    // test bits
    var triangleBuffer: MTLBuffer
    var indexBuffer: MTLBuffer
    var texture: MTLTexture

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
        
        triangleBuffer = device.makeBuffer(bytes: verticies,
                                           length: MemoryLayout.stride(ofValue: verticies[0]) * verticies.count,
                                           options: MTLResourceOptions.storageModeShared)!
        
        indexBuffer = device.makeBuffer(bytes: indicies,
                                        length: MemoryLayout.stride(ofValue: indicies[0]) * indicies.count,
                                        options: MTLResourceOptions.storageModeShared)!
        
        let textureLoader = MTKTextureLoader(device: self.device)
        
        do {
            self.texture = try textureLoader.newTexture(name: "player",
                                                    scaleFactor: 1.0,
                                                    bundle: Bundle.main,
                                                    options: [MTKTextureLoader.Option.textureStorageMode : 0])
        } catch {
            fatalError("Error when Loading Texture: \(error)")
        }
        
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

    func draw(in view: MTKView) {
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
        
        renderEncoder.setVertexBuffer(self.triangleBuffer, offset: 0, index: 30)
        
        renderEncoder.setFragmentTexture(self.texture, index: 0)
        
        renderEncoder.drawIndexedPrimitives(type: .triangle,
                                            indexCount: indexBuffer.length / MemoryLayout<UInt16>.size,
                                            indexType: .uint16,
                                            indexBuffer: self.indexBuffer,
                                            indexBufferOffset: 0)
        
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

// Generic matrix math utility functions
func matrix4x4_rotation(radians: Float, axis: SIMD3<Float>) -> matrix_float4x4 {
    let unitAxis = normalize(axis)
    let ct = cosf(radians)
    let st = sinf(radians)
    let ci = 1 - ct
    let x = unitAxis.x, y = unitAxis.y, z = unitAxis.z
    return matrix_float4x4.init(columns:(vector_float4(    ct + x * x * ci, y * x * ci + z * st, z * x * ci - y * st, 0),
                                         vector_float4(x * y * ci - z * st,     ct + y * y * ci, z * y * ci + x * st, 0),
                                         vector_float4(x * z * ci + y * st, y * z * ci - x * st,     ct + z * z * ci, 0),
                                         vector_float4(                  0,                   0,                   0, 1)))
}

func matrix4x4_translation(_ translationX: Float, _ translationY: Float, _ translationZ: Float) -> matrix_float4x4 {
    return matrix_float4x4.init(columns:(vector_float4(1, 0, 0, 0),
                                         vector_float4(0, 1, 0, 0),
                                         vector_float4(0, 0, 1, 0),
                                         vector_float4(translationX, translationY, translationZ, 1)))
}

func matrix_perspective_right_hand(fovyRadians fovy: Float, aspectRatio: Float, nearZ: Float, farZ: Float) -> matrix_float4x4 {
    let ys = 1 / tanf(fovy * 0.5)
    let xs = ys / aspectRatio
    let zs = farZ / (nearZ - farZ)
    return matrix_float4x4.init(columns:(vector_float4(xs,  0, 0,   0),
                                         vector_float4( 0, ys, 0,   0),
                                         vector_float4( 0,  0, zs, -1),
                                         vector_float4( 0,  0, zs * nearZ, 0)))
}

func radians_from_degrees(_ degrees: Float) -> Float {
    return (degrees / 180) * .pi
}
