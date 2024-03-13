//
//  MTKView+Extensions.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/12/24.
//

import Foundation
import MetalKit

extension MTKView {
    open override var acceptsFirstResponder: Bool { return true }
    
    open override func keyDown(with event: NSEvent) {
        Keyboard.setKeyPressed(event.keyCode, isOn: true)
    }
    
    open override func keyUp(with event: NSEvent) {
        Keyboard.setKeyPressed(event.keyCode, isOn: false)
    }
}
