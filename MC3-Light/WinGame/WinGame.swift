//
//  WinGame.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 03/03/23.
//

import Foundation
import SpriteKit

class WinGame: SKScene
{
    var objectAnimator = ObjectAnimator()
    
    
    override func didMove(to view: SKView) {
        
        objectAnimator.setupWinGameAnimation(scene: self)
        
    }
}
