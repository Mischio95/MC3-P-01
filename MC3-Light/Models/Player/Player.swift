//
//  Player.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 21/02/23.
//

import SpriteKit



class Player
{
    var sprite: SKSpriteNode
    var size: CGSize
    var normalTexture: SKTexture!
    var newPosition = CGPoint.zero
    
   //Life
    var maxCharge: Float = 100
    var currentCharge: Float = 30
    var lightIsOn: Bool = true
    var lightButtonClicked = false
    var playerHit = false
    
    //Collision
    var nearBoxCharge:Bool = false
    var nearLadder:Bool = false
    var nearFloppy: Bool = false
   
    //Animation
    var playerAnimator = PlayerAnimator()
    var isMoving = false
    var isOnLadder:Bool = false
    var isJumping = false
    var isFalling = false
    var isCharging = false
    
    // MOVE
    var maxJump: Float = 230
    var canMove: Bool = true
    let velocityMultiplier: CGFloat = 0.08
  
    
    init(sprite: SKSpriteNode, size: CGSize)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.name = "player"
        self.sprite.zPosition = 100
//        self.sprite.zRotation = -1.5708
        self.sprite.lightingBitMask = 1
        self.sprite.zPosition = 2
        self.sprite.position = CGPoint(x: -960, y: -168)
        setup()
    }
    
    func setup()
    {
        let playerBoxCollision = CGSize(width: self.size.width - 40, height: self.size.height)
        newPosition = sprite.position
        sprite.physicsBody = SKPhysicsBody(rectangleOf: playerBoxCollision)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.density = 2
        sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.friction = 0.0;
        self.sprite.physicsBody?.restitution = 0.0;
        self.sprite.physicsBody?.linearDamping = 0.0;
        self.sprite.physicsBody?.angularDamping = 0.0;
    }
    
   
    
    func removeLife(light: SKLightNode)
    {
        print("RemoveLife")
//        timerNode.fontSize = 30
//        timerNode.zPosition = 30
//        timerNode.position = CGPoint(x: sprite.position.x + 100, y: sprite.position.y + 100)
    }
    
    func hitAnimation(progressBar : ProgressBar)
    {
        if playerHit
        {
            progressBar.startPlayerAnimationProgressBar()
            playerHit = false
        }
        else
        {
            progressBar.startPlayerIdleAnimationProgressBar()
        }
    }

}
