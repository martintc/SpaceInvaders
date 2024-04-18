//
//  LevelProtocol.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/18/24.
//

import MetalKit

protocol LevelProtocol {
    var gameObjects: [NodeProtocol] { get set }
    var camera: Camera { get set }
    
    func load()
    func render(renderEncoder: MTLRenderCommandEncoder)
    func update()
}
