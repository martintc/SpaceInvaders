//
//  TextGenerator.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 4/23/24.
//

import Foundation
import simd

func getRenderedText(text: String, startingPosition: simd_float3, scale: simd_float3, spacing: Float) -> GenericNode {
    let text = text.uppercased()
    
    var genericNode = GenericNode(name: "text")
    
    var position = startingPosition
    
    for c in text {
        if c == " " {
            position.x += spacing
            continue
        }
        
        let characterSprite = TextSprite(name: "\(c)")
        characterSprite.position = position
        characterSprite.scale = scale
        genericNode.addChildNode(characterSprite)
        position.x += spacing
    }
    
    return genericNode
}
