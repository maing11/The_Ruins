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
    
    static func getCoordinatesNeededToMoveToReachNode(form vector1: SCNVector3, to vector2: SCNVector3) -> (vX: Float,vZ:Float,angle:Float) {
        let dx = vector2.x - vector1.x
        let dz = vector1.z - vector1.z
        let angle = atan2(dz, dx)
        
        let vx = cos(angle)
        let vz = sin(angle)
        
        return(vx,vz,angle)
    }
    
    //fix 90 degrees difference
    static func getFixedRotationAngle(with angle: Float) -> Float {
        return (Float.pi/2) - angle
    }
}
