//
//  MacOSViewController.swift
//  Bezier3D
//
//  Created by Patryk Edyko on 28/07/2021.
//

import Cocoa

extension ViewController
{
    func addGestureRecognizers(to view: NSView) {
        let pan = NSPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func handlePan(gesture: NSPanGestureRecognizer)
    {
        let translation = gesture.translation(in: gesture.view)
        renderer?.camera.rotate(delta: [Float(translation.x), Float(translation.y)])
        gesture.setTranslation(.zero, in: gesture.view)
    }
    
    override func scrollWheel(with event: NSEvent) {
        renderer?.camera.zoom(by: Float(event.deltaY))
    }
}
