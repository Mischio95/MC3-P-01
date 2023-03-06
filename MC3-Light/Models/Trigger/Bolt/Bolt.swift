//
//  Bolt.swift
//  MC3-Light
//
//  Created by Kiar on 05/03/23.
//

import Foundation
import SpriteKit

class Bolt: Item
{
    var amount: Int = 0
    
    init(quantity: Int)
   {
       super.init(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 20, height: 20), quantity: quantity)
       self.sprite.name = "bolt"
   }
}
