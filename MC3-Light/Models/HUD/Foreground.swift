
//  Foreground.swift
//  MC3-Light
//
//  Created by Kiar on 28/02/23.
//

import Foundation
import SpriteKit
import SwiftUI

class Foreground
{
    var foreground: SKSpriteNode!
    var allBackgrounds: [SKSpriteNode] = []
    
    func setupForeground(scene: SKScene, nameBackground: String)
    {
        foreground = (scene.childNode(withName: nameBackground) as? SKSpriteNode)
        foreground.lightingBitMask = 1
        foreground.color = .darkGray
        foreground.colorBlendFactor = 1
        foreground.zPosition = -1
        foreground.anchorPoint = CGPoint(x:0.5, y:0.5)
        foreground.zPosition = -100
    }
   
}
