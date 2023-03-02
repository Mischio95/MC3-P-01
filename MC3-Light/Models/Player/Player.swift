//
//  Player.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 21/02/23.
//

import SpriteKit



class Player
{
    
    var videoToPlay: SKVideoNode = SKVideoNode()
    var videoIsPlaying: Bool = false
    
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
    var maxJump: Float = 0
    var canMove: Bool = true
    let velocityMultiplier: CGFloat = 0.08
  
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
    
    init(sprite: SKSpriteNode, size: CGSize, scene: SKScene, progressBar: ProgressBar, light: SKLightNode)
    {
        self.sprite = sprite
        self.size = size
        self.sprite.name = "player"
        self.sprite.zPosition = 100
//        self.sprite.zRotation = -1.5708
        self.sprite.lightingBitMask = 1
        self.sprite.zPosition = 2
        self.sprite.position = CGPoint(x: -960, y: -168)
        self.scene = scene
        self.progressBar = progressBar
        self.light = light
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
        
        if(!isCharging)
        {
            time -= 1
//            print("Time: \(time)")
            if(time <= 0)
            {
                playerDeath()
            }
            if(time % 1 == 0)
            {
                light.falloff = light.falloff + 0.2
                progressBar.updateProgressBar(time: CGFloat(time))
                if time <= 10
                {
                    if time % 3 == 0
                    {
                        if !videoIsPlaying
                        {
                            videoToPlay = SKVideoNode(fileNamed: "glitch4.mov")
                            scene.addChild(videoToPlay)
                            playGlitchVideo()
                        }
                    }
                }
            }
        }
    }
    
    
    func removeLife(light: SKLightNode)
    {
        time -= 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001)
        {
            self.playerAnimator.startHitAnimation(player: self)
        }
    }
    
    func chargingPlayer()
    {
        chargingBite = SKAudioNode(fileNamed: "charge.wav")
        isCharging = true
        timerNode.isPaused = false
        scene.addChild(chargingBite)
        time = 30
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5)
        {
            if(self.lightIsOn)
            {
                self.timerNode.isPaused = false
            }
            self.chargingBite.run(SKAction.stop())
            self.isCharging = false
            self.chargingBite.removeFromParent()
            self.light.falloff = 0.1
        }
    }
    
    func playerDeath()
    {
        let transition = SKTransition.fade(with: .black, duration: 1)
        let restartScene = SKScene(fileNamed: "GameOver") as! GameOver
        restartScene.scaleMode = .aspectFill
        scene.view?.presentScene(restartScene, transition: transition)
    }
    
    func playGlitchVideo()
    {
        self.videoToPlay.play()
        self.videoToPlay.zPosition = self.sprite.zPosition + 10
        self.videoToPlay.position = self.sprite.position
        self.videoIsPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            self.stopGlitchVideo()
        }
    }
    
    func stopGlitchVideo()
    {
        self.videoIsPlaying = false
        self.videoToPlay.removeFromParent()
    }

}
