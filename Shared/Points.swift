//
//  Points.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 29/07/2021.
//

import MetalKit

class Points : Drawable {
    
    private let initial: [SIMD3<Float>]
    private let drawablePoint: Point
    private let drawableLine: Line

    var t: Float = 0.0
    var path: [SIMD3<Float>] = []
    
    init(initial: [SIMD3<Float>], device: MTLDevice, library: MTLLibrary)
    {
        self.initial = initial
        self.drawablePoint = Point(device: device, library: library)
        self.drawableLine = Line(device: device, library: library)
    }

    func drawPoint(p: SIMD3<Float>, color: SIMD4<Float> = [1.0, 1.0, 1.0, 1.0], renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices)
    {
        drawablePoint.color = color
        drawablePoint.move(to: p)
        drawablePoint.draw(renderEncoder: renderEncoder, mvp: &mvp)
    }
    
    func drawLine(p1: SIMD3<Float>, p2: SIMD3<Float>, color: SIMD4<Float> = [1.0, 1.0, 1.0, 1.0], renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices)
    {
        drawableLine.color = color
        drawableLine.move(p1: p1, p2: p2)
        drawableLine.draw(renderEncoder: renderEncoder, mvp: &mvp)
    }
    
    func lerp(p1: SIMD3<Float>, p2: SIMD3<Float>, t: Float) -> SIMD3<Float> {
        let x = (1-t) * p1.x + t * p2.x
        let y = (1-t) * p1.y + t * p2.y
        let z = (1-t) * p1.z + t * p2.z
        return [x, y, z]
    }

    func drawPoints(points: [SIMD3<Float>], color: SIMD4<Float> = [1.0, 1.0, 1.0, 1.0], renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices) -> [SIMD3<Float>]
    {
        assert(points.count > 1)
        var interpolatedPoints: [SIMD3<Float>] = []

        drawPoint(p: points.last!, color: color, renderEncoder: renderEncoder, mvp: &mvp)

        for i in 1..<points.count {
            let p1 = points[i-1]
            let p2 = points[i]

            drawPoint(p: p1, color: color, renderEncoder: renderEncoder, mvp: &mvp)
            drawLine(p1: p1, p2: p2, color: color, renderEncoder: renderEncoder, mvp: &mvp)

            let pointBetween = lerp(p1: p1, p2: p2, t: t)

            interpolatedPoints.append(pointBetween)
        }

        return interpolatedPoints
    }
    
    func drawPath(renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices)
    {
        if path.count < 2 {
            return
        }

        for i in 1..<path.count
        {
            let p1 = path[i-1]
            let p2 = path[i]
            drawLine(p1: p1, p2: p2, color: [1.0, 0.0, 0.0, 1.0], renderEncoder: renderEncoder, mvp: &mvp)
        }
    }

    func draw(renderEncoder: MTLRenderCommandEncoder, mvp: inout MVPMatrices) {

        var points = initial

        repeat {
            let color: SIMD4<Float> = points.count == initial.count ? [1.0, 1.0, 1.0, 1.0] : [1.0, 1.0, 1.0, 0.25]
            points = drawPoints(points: points, color: color, renderEncoder: renderEncoder, mvp: &mvp)
        } while points.count > 1

        assert(points.count == 1)
        drawPoint(p: points.first!, renderEncoder: renderEncoder, mvp: &mvp)
        path.append(points.first!)
        drawPath(renderEncoder: renderEncoder, mvp: &mvp)
    }
}
