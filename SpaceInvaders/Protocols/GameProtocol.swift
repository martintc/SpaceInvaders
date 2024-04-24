//
//  GameProtocol.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/18/24.
//

import Foundation
import MetalKit

protocol GameProtocol {
    var levels: [any LevelProtocol] { get set }
    var currentLevel: Int { get set }
    var prevTime: Double { get set }
    
    init()
    func load()
    mutating func update()
    func render(encoder: MTLRenderCommandEncoder)
}
