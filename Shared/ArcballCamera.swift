//
//  ArcballCamera.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 27/07/2021.
//

import ModelIO

class ArcballCamera {
    private var phi: Float = 0
    private var theta: Float = 0
    private var r: Float = 4
    private var target: vector_float3 = [0.0, 0.0, 0.0]
    private let rotationSensitivity: Float = 0.005
    private let zoomSensitivity: Float = 0.05
    private let camera: MDLCamera = MDLCamera()
    private let transform: MDLTransform
    
    var projectionMatrix: matrix_float4x4 { camera.projectionMatrix }
    
    var viewMatrix: matrix_float4x4 { transform.matrix.inverse }
    
    var sensorAspect: Float {
        get { camera.sensorAspect }
        set { camera.sensorAspect = newValue }
    }
    
    init()
    {
        camera.nearVisibilityDistance = 0.001
        camera.farVisibilityDistance = 100
        camera.fieldOfView = 45
        transform = camera.transform as! MDLTransform
        update()
    }
    
    private func positionOnSphere()
    {
        transform.translation.x = r * sin(phi) * cos(theta)
        transform.translation.y = r * sin(theta)
        transform.translation.z = r * cos(phi) * cos(theta)
    }
    
    private func moveToTarget()
    {
        transform.translation += target
    }
    
    private func lookAtTarget()
    {
        camera.look(at: target)
    }
    
    private func updatePhi(dx: Float)
    {
        phi -= dx * rotationSensitivity
    }
    
    private func updateTheta(dy: Float)
    {
        theta -= dy * rotationSensitivity
    }
    
    private func limitTheta() // TODO change name to elevation/azimuth
    {
        theta = max(-Float.pi/2, min(theta, Float.pi/2))
    }
    
    private func update()
    {
        limitTheta()
        positionOnSphere()
        moveToTarget()
        lookAtTarget()
    }
    
    func rotate(phi: Float, theta: Float)
    {
        self.phi = phi
        self.theta = theta
        update()
    }
    
    func rotate(delta: SIMD2<Float>)
    {
        updatePhi(dx: delta.x)
        updateTheta(dy: delta.y)
        update()
    }
    
    func zoom(by diff: Float)
    {
        r += diff * zoomSensitivity
        r = max(zoomSensitivity, r)
        update()
    }
    
    private func moveTarget(delta: SIMD3<Float>)
    {
        target += delta
    }
    
    private func moveCamera(delta: SIMD3<Float>)
    {
        transform.translation += delta
    }
    
    func move(x by: Float)
    {
        let dx = by * rotationSensitivity
        moveTarget(delta: [dx,0,0])
        moveCamera(delta: [dx,0,0])
        update()
    }
    
    func move(y by: Float)
    {
        let dy = by * rotationSensitivity
        moveTarget(delta: [0,dy,0])
        moveCamera(delta: [0,dy,0])
        update()
    }
    
    func move(z by: Float)
    {
        let dz = by * rotationSensitivity
        moveTarget(delta: [0,0,dz])
        moveCamera(delta: [0,0,dz])
        update()
    }
}
