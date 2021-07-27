//
//  Renderer.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 26/07/2021.
//

import MetalKit

class Renderer : NSObject {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let library: MTLLibrary
    
    var sphere: Sphere
    var mvp: MVPMatrices = MVPMatrices()
    let camera: ArcballCamera = ArcballCamera()
    
    init(metalView: MTKView) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue(),
            let library = device.makeDefaultLibrary()
        else {
            fatalError("GPU not available.")
        }
        
        self.device = device
        self.commandQueue = commandQueue
        self.library = library
        
        sphere = Sphere(device: device, library: library)
        
        super.init()

        metalView.device = device
        metalView.clearColor = MTLClearColor(red: 0.0, green: 0.07, blue: 0.2, alpha: 1.0)
        metalView.delegate = self
        
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
}

extension Renderer : MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        camera.sensorAspect = Float(view.bounds.width) / Float(view.bounds.height)
    }

    func draw(in view: MTKView) {
        guard
            let descriptor = view.currentRenderPassDescriptor,
            let commandBuffer = commandQueue.makeCommandBuffer(),
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else {
            print("Could not set up variables in draw function");
            return
        }

        mvp.view = camera.viewMatrix
        mvp.projection = camera.projectionMatrix

        sphere.draw(renderEncoder: renderEncoder, mvp: &mvp)
        
        renderEncoder.endEncoding()
        guard let drawable = view.currentDrawable else {
            print("Could not set drawable")
            return
        }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
