//
//  Model.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 28/07/2021.
//

import ModelIO
import MetalKit

class Model : Drawable {
    let mdlMesh: MDLMesh
    let mtkMesh: MTKMesh
    let pipelineState: MTLRenderPipelineState
    
    var drawPrimitiveType: MTLPrimitiveType = .triangle
    var color: SIMD4<Float> = [1.0, 1.0, 1.0, 1.0]

    var transform: MDLTransform {
        guard let transform = mdlMesh.transform as? MDLTransform else {
            fatalError("Missing model transformation.")
        }
        return transform
    }
    
    var modelMatrix: matrix_float4x4 {
        guard let modelMatrix = mdlMesh.transform?.matrix else {
            fatalError("Missing model transformation matrix.")
        }
        return modelMatrix
    }
    
    init(mdlMesh: MDLMesh, device: MTLDevice, library: MTLLibrary)
    {
        self.mdlMesh = mdlMesh
        if mdlMesh.transform == nil {
            mdlMesh.transform = MDLTransform()
        }

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
        pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func draw(renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices) {
        mvp.model = modelMatrix

        renderEncoder.setVertexBytes(&mvp, length: MemoryLayout<MVPMatrices>.stride, index: 1)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(mtkMesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        renderEncoder.setFragmentBytes(&color, length: MemoryLayout<SIMD3<Float>>.stride, index: 0)
        for submesh in mtkMesh.submeshes
        {
            renderEncoder.drawIndexedPrimitives(type: drawPrimitiveType,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        }
    }
}
