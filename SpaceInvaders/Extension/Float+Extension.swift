//
//  Float+Extension.swift
//  SpaceInvaders
//
//  Created by Todd Martin on 3/12/24.
//

extension Float {
    static func toRadians(from angle: Float) -> Float {
        return angle * 180.0 / .pi;
    }
    
    static func toDegrees(from angle: Float) -> Float {
        return angle * (180.0 / .pi)
    }
}
