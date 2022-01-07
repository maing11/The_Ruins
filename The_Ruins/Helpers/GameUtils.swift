//
//  GameUtils.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/6/22.
//

import Foundation
import SceneKit

struct GameUtils {
    static func distanceBetweenVectors(vector1: SCNVector3, vector2:SCNVector3) -> Float {
        let vector = SCNVector3Make(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z - vector2.z)
        
        return sqrt(pow((vector.x), 2.0) + pow(vector.y,2.0) + pow(vector.z,2.0))
    }
}
