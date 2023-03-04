//
//  Trigger.swift
//  MC3-Light
//
//  Created by Kiar on 22/02/23.
//

import Foundation
import SpriteKit

class Trigger
{
    var sprite: SKSpriteNode
    var size: CGSize
    
    init(sprite: SKSpriteNode, size: CGSize)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.size = size
        setup()
    }
    
    func setup()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: size)
        sprite.physicsBody?.isDynamic = true
    }
}

class ChargingBox: Trigger {
    
    override init(sprite: SKSpriteNode, size: CGSize) {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "chargingBox"
        setup()
    }
    
    override func setup() {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width + 60, height: sprite.size.width + 10))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.allowsRotation = false
        sprite.lightingBitMask = 1
    }
}



class Bullet: Trigger
{
    var speed: Float = 1
    
    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "winBox"
        self.sprite.isHidden = true
        setup()
    }
    func bulletFollowPlayer(player: SKSpriteNode, enemyCauser: SKSpriteNode)
    {
        
        let moveAction = SKAction.move(to: player.position, duration: TimeInterval(self.speed))
        self.sprite.run(moveAction)
    }
}

class SoundTrigger: Trigger
{
    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "soundTrigger"
        self.sprite.isHidden = false
        setup()
    }
    
    override func setup() {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height + 1000))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.soundTriggerCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
    }
}

class EnemyViewTrigger: Trigger
{
    override init(sprite: SKSpriteNode, size: CGSize)
    {
        super .init(sprite: sprite, size: size)
        self.sprite.name = "enemyView"
        setup()
    }
    
    override func setup()
    {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height + 500))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.enemyViewCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
    }
}
