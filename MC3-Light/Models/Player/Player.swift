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
    var light = SKLightNode()
    var progressBar = ProgressBar()
    var lightRed = SKLightNode()
    
    
    init(sprite: SKSpriteNode, size: CGSize, scene: SKScene, progressBar: ProgressBar, light: SKLightNode)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.position = CGPoint(x: -960, y: -176)
        self.scene = scene
        self.progressBar = progressBar
        self.light = light
        setup()
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
        sprite.physicsBody?.density = 2.1
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        sprite.name = "player"
        sprite.zPosition = 100
//        self.sprite.zRotation = -1.5708
        self.sprite.lightingBitMask = 1
        self.sprite.physicsBody?.friction = 0.0;
        self.sprite.physicsBody?.restitution = 0.0;
        self.sprite.physicsBody?.linearDamping = 0.0;
        self.sprite.physicsBody?.angularDamping = 0.0;
        scene.addChild(sprite)
    }
    
    func setupNewLight()
    {
        lightRed.position = light.position
        lightRed.falloff = light.falloff
        lightRed.lightColor = .red
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
    
    func countdownPlayerPointLightBattery()
    {
        if lightButtonClicked
        {
            removeLife(light: light)
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
                light.falloff = light.falloff + 0.2
                progressBar.updateProgressBar(time: CGFloat(time))
                if time <= 10
                {
//                    light.lightColor = UIColor(red: 112, green: 23, blue: 4, alpha: 0.02)
                      light.lightColor = UIColor(red: 60, green: 1, blue: 1, alpha: 0.013)

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
    
    func removeLife(light: SKLightNode)
    {
        if(!videoFloppyIsPlaying && !isCharging)
        {
            time -= 5
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
        self.videoToPlay.zPosition = self.sprite.zPosition + 10
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
        if(!self.isCharging && !self.videoFloppyIsPlaying)
        {
            self.playerAnimator.startHitAnimation(player: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
            {
                if(joystickButtonClicked)
                {
                    self.playerAnimator.startRunningAnimation(player: self)
                }
                else
                {
                    self.playerAnimator.startIdleAnimation(player: self)
                }
            }
        }
    }
    
    func chargingPlayer()
    {
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
                self.light.falloff = 0.1
                self.light.lightColor = .white
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
    
    
//    func playerWin()
//    {
//        let transition = SKTransition.fade(with: .black, duration: 1)
//        let restartScene = SKScene(fileNamed: "WinGame") as! WinGame
//        restartScene.scaleMode = .aspectFill
//        self.scene.view?.presentScene(restartScene, transition: transition)
//
//    }
}
