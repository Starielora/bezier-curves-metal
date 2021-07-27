//
//  Sphere.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 27/07/2021.
//

import MetalKit
import ModelIO

class Sphere {
    
    private let mdlMesh: MDLMesh
    private let mtkMesh: MTKMesh
    private let pipelineState: MTLRenderPipelineState
    
    var modelMatrix: matrix_float4x4 {
        guard let modelMatrix = mdlMesh.transform?.matrix else {
            fatalError("Missing model transformation matrix.")
        }
        return modelMatrix
    }
    
    init(device: MTLDevice, library: MTLLibrary)
    {
        let allocator = MTKMeshBufferAllocator(device: device)
        mdlMesh = MDLMesh(sphereWithExtent: [1.0, 1.0, 1.0], segments: [10, 10], inwardNormals: false, geometryType: .lines, allocator: allocator)
        mdlMesh.transform = MDLTransform()

        do {
            mtkMesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch let error {
            fatalError(error.localizedDescription)
        }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()

        pipelineDescriptor.vertexFunction = library.makeFunction(name: "vertexPosition")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "color")
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func draw(renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices)
    {
        mvp.model = modelMatrix

        renderEncoder.setVertexBytes(&mvp, length: MemoryLayout<MVPMatrices>.stride, index: 1)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(mtkMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        for submesh in mtkMesh.submeshes
        {
            renderEncoder.drawIndexedPrimitives(type: .lineStrip,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        }
    }
}
