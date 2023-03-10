//
//  Player.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 21/02/23.
//

import SpriteKit



class Player
{
    var playerStar: SKNode!
    var imDeathing = false
    var videoToPlay: SKVideoNode = SKVideoNode()
    var videoGlitchIsPlaying: Bool = false
    var videoFloppyIsPlaying: Bool = false
    var damageLight: Bool = false
    var nearGate: Bool = false
    
    var sprite: SKSpriteNode
    var size: CGSize
    var normalTexture: SKTexture!
    var newPosition = CGPoint.zero
    var light = Light()
    var inventory = PlayerInventory()
    
    var videoPlay = FloppyDisk(videoName: [])
    
   //Life
    var maxCharge: Float = 100
    var currentCharge: Float = 30
    var lightIsOn: Bool = true
    var lightButtonClicked = false
    var playerHit = false
    
    //Collision
    var nearBoxCharge:Bool = false
    var nearWinBox:Bool = false
    var nearFloppy: Bool = false
    var nearPickup: Bool = false
   
    //Animation
    var playerAnimator = PlayerAnimator()
    var isMoving = false
    var isOnLadder:Bool = false
    var isJumping = false
    var isFalling = false
    var isCharging = false
    
    // MOVE
    var maxJump: Float = 220
    var canMove: Bool = true
    let velocityMultiplier: CGFloat = 0.08
    var canJump = true
  
    //Sounds
    var chargingBite = SKAudioNode(fileNamed: "Charging.mp3")

    //TIMER
    let timerNode : SKLabelNode = SKLabelNode(fontNamed: "")
    var time : Int = 30
    {
        didSet
        {
            if(time >= 30)
            {
                timerNode.text = "\(time)"
            }
            else
            {
                timerNode.text = "0\(time)"
            }
        }
    }
    
    var scene = SKScene()
    var progressBar = ProgressBar()
    var lightRed = SKLightNode()
    
    
    init(sprite: SKSpriteNode, size: CGSize, scene: SKScene, progressBar: ProgressBar)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.position = CGPoint(x: -960, y: -176)
        self.scene = scene
        self.progressBar = progressBar
        setup()
        light.initLight(scene: scene)
//        setupNewLight()
        
    }
   
    
    //MARK: - setup PLAYER
    func setup()
    {
        let playerBoxCollision = CGSize(width: self.size.width - 40, height: self.size.height)
        playerStar = scene.childNode(withName: "PlayerStart")
        playerStar.isHidden = true
        sprite.position = playerStar.position
        newPosition = sprite.position
        sprite.size = size
        sprite.physicsBody = SKPhysicsBody(rectangleOf: playerBoxCollision)
        sprite.physicsBody?.isDynamic = true
//        sprite.physicsBody?.density = 2.1
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.groundCategory
        sprite.name = "player"
        sprite.zPosition = Utilities.ZIndex.player
//        self.sprite.zRotation = -1.5708
        self.sprite.lightingBitMask = 1
        self.sprite.physicsBody?.friction = 0.0;
        self.sprite.physicsBody?.restitution = 0.0;
        self.sprite.physicsBody?.linearDamping = 0.0;
        self.sprite.physicsBody?.angularDamping = 0.0;
        scene.addChild(sprite)
    }
//
//    func setupNewLight()
//    {
//        lightRed.position = light.position
//        lightRed.falloff = light.falloff
//        lightRed.lightColor = .red
//    }
    
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
    
    func countdownPlayerPointLightBattery()
    {
        if lightButtonClicked
        {
            removeLife(damage: 5)
            lightButtonClicked = false
            playerHit = true
            hitAnimation(progressBar: self.progressBar)
        }
        else
        {
            progressBar.startPlayerIdleAnimationProgressBar()
        }
        
        if(!isCharging && !videoFloppyIsPlaying)
        {
            time -= 1
//            print("Time: \(time)")
            if(time <= 0)
            {
                playerDeath()
            }
//            if(time % 1 == 0)
//            {
                light.light.falloff = light.light.falloff + 0.2
                progressBar.updateProgressBar(time: CGFloat(time))
                if time <= 10
                {
//                    light.lightColor = UIColor(red: 112, green: 23, blue: 4, alpha: 0.02)
                    light.light.lightColor = UIColor(red: 60, green: 1, blue: 1, alpha: 0.013)

                    if time % 3 == 0
                    {
                        if !videoGlitchIsPlaying
                        {
                            videoToPlay = SKVideoNode(fileNamed: "glitch4.mov")
                            scene.addChild(videoToPlay)
                            playGlitchVideo()
                        }
                    }
//                }
            }
        }
    }
    
    func removeLife(damage: Int)
    {
        if(!videoFloppyIsPlaying && !isCharging)
        {
            time -= damage
        }
    }
    
    func playerDeath()
    {
        let transition = SKTransition.fade(with: .black, duration: 1)
        let restartScene = SKScene(fileNamed: "GameOver") as! GameOver
        restartScene.scaleMode = .aspectFill
        self.scene.view?.presentScene(restartScene, transition: transition)
    }
    
    func playGlitchVideo()
    {
        self.videoToPlay.play()
        self.videoToPlay.zPosition = Utilities.ZIndex.videoFloppy
        self.videoToPlay.position = self.sprite.position
        self.videoGlitchIsPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.stopGlitchVideo()
        }
    }
    
    func stopGlitchVideo()
    {
        self.videoGlitchIsPlaying = false
        self.videoToPlay.removeFromParent()
    }
    
    func hitAfterTurnOnLight()
    {
        if(!self.isCharging && !self.videoFloppyIsPlaying && !self.playerHit)
        {
            self.damageLight = true
            self.playerAnimator.startHitAnimation(player: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
            {
                if(joystickButtonClicked)
                {
                    self.playerAnimator.startRunningAnimation(player: self)
                }
                else
                {
                    self.playerAnimator.startIdleAnimation(player: self)
                }
                self.damageLight = false
            }
        }
    }
    
    func chargingPlayer()
    {
        if(self.isFalling || self.isJumping)
        {
            self.sprite.removeAllActions()
        }
        if(!self.isCharging && !self.videoFloppyIsPlaying)
        {
            self.canMove = false
            self.isCharging = true
            self.playerAnimator.startChargeAnimation(player: self)
            chargingBite = SKAudioNode(fileNamed: "charge.wav")
            
             timerNode.isPaused = false
             scene.addChild(chargingBite)
             time = 30
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3)
            {
                if(self.lightIsOn)
                {
                    self.timerNode.isPaused = false
                }
                self.chargingBite.run(SKAction.stop())
                self.isCharging = false
                self.chargingBite.removeFromParent()
                self.light.light.falloff = 0.1
                self.light.light.lightColor = .white
                self.isCharging = false
                
                if(joystickButtonClicked)
                {
                    self.playerAnimator.startRunningAnimation(player: self)
                }
                else
                {
                    self.playerAnimator.startIdleAnimation(player: self)
                }
                self.canMove = true
            }
        }
    }


    
    func Jump()
    {
        self.sprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: Int(self.maxJump)))
        self.playerAnimator.startJumpAnimation(player: self)
    }
    
    func playerWin()
    {
        let transition = SKTransition.fade(with: .black, duration: 1)
        let restartScene = SKScene(fileNamed: "WinGame") as! WinGame
        restartScene.scaleMode = .aspectFill
        self.scene.view?.presentScene(restartScene, transition: transition)

    }
}
