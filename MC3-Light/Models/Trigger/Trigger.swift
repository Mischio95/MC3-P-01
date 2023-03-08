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
//        sprite.physicsBody?.isDynamic = true
//        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width + 60, height: sprite.size.width + 10))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.allowsRotation = false
        sprite.lightingBitMask = 1
    }
}

class ChargingBox: Trigger {
    
    var scene = SKScene()
    var player: Player?
    
    init(scene: SKScene, player: Player) {
        super .init(sprite: SKSpriteNode(imageNamed: "base_ricarica"), size: CGSize(width: 18, height: 18))
        self.sprite.name = "chargingBox"
        setup()
        self.player = player
        self.scene = scene
        setupChargingBox()
    }
    
    override func setup() {
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width + 60, height: sprite.size.width + 10))
        sprite.physicsBody?.isDynamic = false
        sprite.physicsBody?.allowsRotation = false
        sprite.lightingBitMask = 1
    }
    
    //MARK: - setup CHARGING BOX
    func setupChargingBox()
    {
        sprite.size = CGSize(width: 220, height: 60)
        sprite.zPosition = Utilities.ZIndex.sceneObject
        sprite.physicsBody!.isDynamic = true
        sprite.lightingBitMask = 1
        sprite.physicsBody!.categoryBitMask = Utilities.CollisionBitMask.chargingBoxCategory
        sprite.physicsBody!.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        scene.addChild(sprite)
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
