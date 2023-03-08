//
//  GameMode.swift
//  MC3-Light
//
//  Created by Kiar on 06/03/23.
//

import Foundation
import SpriteKit

class GameMode
{
    var scene: SKScene
   
    var keyCardsInScene: [PickupItem] = []

    
    
    init(scene: SKScene)
    {
        self.scene = scene
    }
}
