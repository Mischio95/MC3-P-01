//
//  Enemy.swift
//  MC3-Light
//
//  Created by Kiar on 23/02/23.
//

import Foundation
import SpriteKit

protocol Updatable: AnyObject {
    func update(currentTime: Double)
}

class Enemy: Trigger, Updatable {
    
    var isChasingPlayer: Int = 3
    var isAtacking: Bool = false
    var lastLeftPosition: CGPoint = CGPoint.zero
    var lastRightPosition: CGPoint = CGPoint.zero
    var isInLife: Bool = false
    
    override init(sprite: SKSpriteNode, size: CGSize) {
        super.init(sprite: sprite, size: size)
//        setupView()
        animEnemy()
    }
    
    func update(currentTime: Double) {
        
        self.enemyViewRight.sprite.position.x = self.sprite.position.x + 500
        self.enemyViewRight.sprite.position.y = self.sprite.position.y
        
        self.enemyViewLeft.sprite.position.x = self.sprite.position.x - 500
        self.enemyViewLeft.sprite.position.y = self.sprite.position.y
    }
    
    var speed: Float = 5
    var enemyViewLeft =  EnemyViewTrigger(sprite: SKSpriteNode(imageNamed: "player"), size: CGSize(width: 5, height: 5))
    var enemyViewRight =  EnemyViewTrigger(sprite: SKSpriteNode(imageNamed: "player"), size: CGSize(width: 5, height: 5))
    
    private var enemySpriteAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "Enemy")
    }
    
    private var enemyAnimMove: [SKTexture]
    {
        return[enemySpriteAtlas.textureNamed("enemyAnim1"),
               enemySpriteAtlas.textureNamed("enemyAnim2"),
               enemySpriteAtlas.textureNamed("enemyAnim3"),
               enemySpriteAtlas.textureNamed("enemyAnim4"),
               enemySpriteAtlas.textureNamed("enemyAnim5")]
    }
    
    func setupSprite(scene: SKScene)
    {
        self.sprite.name = "enemy"
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: sprite.size.width, height: sprite.size.height / 2))
        self.sprite.physicsBody?.isDynamic = true
        self.sprite.physicsBody?.affectedByGravity = true
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.position = scene.childNode(withName: "enemySpownPosition")!.position
        self.sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.enemyCategory
        self.sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        self.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        self.sprite.physicsBody?.friction = 0.0;
        self.sprite.physicsBody?.restitution = 1.0;
        self.sprite.physicsBody?.linearDamping = 0.0;
        self.sprite.physicsBody?.angularDamping = 0.0;
        self.sprite.lightingBitMask = 1
        self.sprite.zPosition = 10
//        scene.addChild(sprite)
    }
    
    func setupView()
    {
        self.enemyViewLeft.sprite.zPosition = 100
        self.enemyViewLeft.sprite.position.x = self.sprite.position.x - 100
        self.enemyViewLeft.sprite.position.y = self.sprite.position.y
        self.enemyViewLeft.sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.enemyViewCategory
        self.enemyViewLeft.sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        self.enemyViewLeft.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        
        self.enemyViewRight.sprite.zPosition = 100
        self.enemyViewRight.sprite.position.x = self.sprite.position.x + 100
        self.enemyViewRight.sprite.position.y = self.sprite.position.y
        self.enemyViewRight.sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.enemyViewCategory
        self.enemyViewRight.sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        self.enemyViewRight.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
    }
    
    func spawnEnemy(scene: SKScene)
    {
        self.sprite.position = scene.childNode(withName: "enemySpownPosition")!.position
        scene.addChild(self.sprite)
        self.isInLife = true
    }
    
    func despawnEnemy(player: Player)
    {
        self.isInLife = false
        player.canMove = false
        sprite.removeFromParent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            player.playerHit = false
            player.canMove = true
            if(joystickButtonClicked)
            {
                player.playerAnimator.starRunningAnimation(player: player)
            }
            else
            {
                player.playerAnimator.startIdleAnimation(player: player)
            }
           
        }
    }
    
    func enemyFollowThePlayer(player: Player)
    {
        var newPosition = CGPoint()
            if(self.sprite.position.x > player.sprite.position.x)
            {
                newPosition = CGPoint(x: self.sprite.position.x - CGFloat(speed),y: self.sprite.position.y)
                self.sprite.xScale = -1
            }
            else
            {
                newPosition = CGPoint(x: self.sprite.position.x + CGFloat(speed),y: self.sprite.position.y)
                self.sprite.xScale = 1
            }
    //            let moveAction = SKAction.move(to: player.sprite.position, duration: TimeInterval(self.speed))
           
            self.sprite.position = newPosition
    }
    
    func randomMove(player: Player , levetta: WaterPipe)
    {
        sprite.isPaused = false
        
        let moveRight = SKAction.moveTo(x: sprite.position.x + 300, duration: 1.5)
        let moveLeft = SKAction.moveTo(x: sprite.position.x - 300, duration: 1.5)
       
        // Sequences run each action one after another, whereas groups run
        // each action in parallel
        let sequence = SKAction.sequence([moveRight,moveLeft])
        let repeatedSequence = SKAction.repeatForever(sequence)

      
        sprite.run(SKAction.repeat(repeatedSequence, count: isChasingPlayer))
        print(sprite.speed)
        isChasingPlayer = 0
        
        if(self.sprite.position.x > levetta.soundTriggerIn.sprite.position.x)
        {
            self.sprite.xScale = -1
        }
        else
        {
            self.sprite.xScale = 1
        }
        
    }
    
    func animEnemy()
    {
        let runEnemy = SKAction.animate(with: enemyAnimMove, timePerFrame: 0.14)
        sprite.run(SKAction.repeatForever(runEnemy), withKey: "EnemyRunAnimation")
    }
}

class RangedEnemy: Enemy
{
   
    var weaponFireSocket: CGPoint = CGPoint(x: 0, y: 0)
   
    override init(sprite: SKSpriteNode, size: CGSize) {
        super.init(sprite: sprite, size: size)
        self.sprite.name = "enemy"
    }
    
    func updateSocket()
    {
        weaponFireSocket = CGPoint(x: sprite.position.x + 50, y: sprite.position.y + 50)
    }
    
    func shooting(bullet: Bullet, player: SKSpriteNode)
    {
        updateSocket()
        bullet.sprite.isHidden = false
        bullet.bulletFollowPlayer(player: player, enemyCauser: self.sprite)
    }
}
