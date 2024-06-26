//
//  GameViewController.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 2/16/24.
//

import Cocoa
import MetalKit

// Our macOS specific view controller
class GameViewController: NSViewController {

    var renderer: Renderer!
    var mtkView: MTKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textSpriteNames = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
        "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        
        TextureLibrary.shared.loadTexture(sourceName: "player", textureName: "player")
        TextureLibrary.shared.loadTexture(sourceName: "yellow", textureName: "alien")
        TextureLibrary.shared.loadSpriteSheet(textureName: "bloxxit_8x8", spriteNames: textSpriteNames, rows: 1, columns: 26)
        ModelLibray.shared.loadModels()

        guard let mtkView = self.view as? MTKView else {
            print("View attached to GameViewController is not an MTKView")
            return
        }

        // Select the device to render with.  We choose the default device
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal is not supported on this device")
            return
        }

        mtkView.device = defaultDevice

        guard let newRenderer = Renderer(metalKitView: mtkView) else {
            print("Renderer cannot be initialized")
            return
        }

        renderer = newRenderer

        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)

        mtkView.delegate = renderer
    }
}
