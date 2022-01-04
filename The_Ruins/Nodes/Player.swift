//
//  Player.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/3/22.
//

import Foundation
import  SceneKit

class Player:SCNNode {
    
    //nodes
    private var daeHolderNode = SCNNode()
    private var characterNode:SCNNode!
    
    override init() {
        super.init()
        setupModel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupModel() {
        // load dae childs
        let playerURL = Bundle.main.url(forResource: "art.scnassets/Scenes/Hero/idle", withExtension: "dae")
        let playerScene = try! SCNScene(url: playerURL!, options: nil)
        
        for child in playerScene.rootNode.childNodes {
            daeHolderNode.addChildNode(child)
        }
        addChildNode(daeHolderNode)
        //set mesh name
        characterNode = daeHolderNode.childNode(withName: "Bip01", recursively: true)!
        
    }
}
