//
//  GameViewController.swift
//  The_Ruins
//
//  Created by mai nguyen on 1/3/22.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    //MARK:- scence
    //MARK:- walls
    //MARK:- camera
    //MARK:- player
    //MARK:- touches + movement
    //MARK:- gameloop functions
    //MARK:- enemies


}
//MARK: extension
