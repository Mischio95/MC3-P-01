//
//  InvisibleWall.swift
//  MC3-Light
//
//  Created by Kiar on 05/03/23.
//

import Foundation
import SpriteKit

class InvisibleWall: Trigger
{
    var active: Bool = false
    
    init(active: Bool)
    {
        super.init(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 50, height: 50))
        self.active = active
        self.sprite.isHidden = !active
        self.sprite.name = "invisibleWall"
        self.sprite.zPosition = Utilities.ZIndex.frontSceneObject
        setup()
    }
    override func setup() {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.pickupItemCategory
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.affectedByGravity = false
        sprite.lightingBitMask = 1
    }
}

//ACTIVATION
extension InvisibleWall
{
    func playerActiveWall(player: Player)
    {
        if(player.lightIsOn)
        {
            deactivateWall()
        }
    }
    
    func activateWall()
    {
        self.sprite.isHidden = false
    }
    
    func deactivateWall()
    {
        self.sprite.removeFromParent()
    }
    
    func revertActivateWall()
    {
        if(self.sprite.isHidden)
        {
            activateWall()
        }
        else
        {
            deactivateWall()
        }
    }
}



//Physics
extension InvisibleWall
{
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
