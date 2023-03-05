//
//  Merchant.swift
//  MC3-Light
//
//  Created by Kiar on 05/03/23.
//

import Foundation
import SpriteKit

class Merchant: Trigger
{
    
    init()
    {
        super.init(sprite: SKSpriteNode(imageNamed: "mercante"), size: CGSize(width: 250, height: 250))
        self.sprite.name = "merchant"
        setupPhyisics()
    }
    
    func setupPhyisics()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.pickupItemCategory
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.affectedByGravity = false
        sprite.lightingBitMask = 1
    }
    
}
