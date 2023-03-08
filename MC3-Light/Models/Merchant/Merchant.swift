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
    var merchantSpown: SKNode!

    var bubbleDialogue = SKSpriteNode(imageNamed: "merchantDialogueBubble")
    var isTalking: Bool = false
    init(scene: SKScene)
    {
        super.init(sprite: SKSpriteNode(imageNamed: "mercante"), size: CGSize(width: 250, height: 250))
        self.sprite.name = "merchant"
        merchantSpown = scene.childNode(withName: "merchantSpown")
        self.sprite.position = merchantSpown.position
        setupPhyisics()
        self.bubbleDialogue.position.x = self.sprite.position.x - 50
        self.bubbleDialogue.position.y = self.sprite.position.y + 80
        self.bubbleDialogue.zPosition = self.sprite.zPosition + 1
        self.bubbleDialogue.size = CGSize(width: 150, height: 150)
    }
    
    func setupPhyisics()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.lightingBitMask = 1
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.merchantCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
//        self.bubbileDialogue.physicsBody?.collisionBitMask = 0
    }
    
    func Talking()
    {
        if(isTalking)
        {
           isTalking = false
            self.bubbleDialogue.removeFromParent()
        }
        else
        {
            isTalking = true
            self.sprite.addChild(bubbleDialogue)
        }
    }
}
