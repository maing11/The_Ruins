//
//  GameView.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/3/22.
//

import SceneKit
import SpriteKit


class GameView: SCNView {
    private var skScene:SKScene!
    private let overlayNode = SKNode()

    override  func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layout2DOverlay()
    }
    deinit {
        
    }
    
    //MARK:- overlay functions
    private func setup2DOverlay(){
        let w = bounds.size.width
        let h = bounds.size.height

        skScene = SKScene(size: CGSize(width: w, height: h))
        skScene.scaleMode = .resizeFill

        skScene.addChild(overlayNode)
        overlayNode.position = CGPoint(x: 0.0, y: h)

        overlaySKScene = skScene
        skScene.isUserInteractionEnabled = false
    }

    private func layout2DOverlay() {
        overlayNode.position = CGPoint(x: 0.0, y: bounds.size.height)
    }
    //MARK:- internal functions
    //MARK:- D-Pad
    //MARK:- attackButton
}
