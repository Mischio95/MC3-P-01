//
//  Tutorial.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 06/03/23.
//

import Foundation
import SpriteKit
import AVFoundation

class Tutorial: SKScene, SKPhysicsContactDelegate
{
    var avPlayer = AVPlayer()
    
    //MARK: PICKUP ITEM
    
    private var video = SKVideoNode(fileNamed: "glitch.mov")
    var blackBackground: SKNode!
    private var updatables = [Updatable]()
    private var lastUpdateTime : TimeInterval = 0
    var groundGameScene1 = SetupMap()
    var progressBar = ProgressBar()
    var floppyDisk1 = FloppyDisk(videoName:["firstVideoTutorial.mov", "secondo-testo.mov","terzo-testo.mov", "quarto-testo.mov", "quinto-testo.mov", "sesto-testo.mov", "settimo-testo.mov"])
    var player: Player!
    var deltaTime: Double!
    var playerStart : SKSpriteNode!
    var objectAnimatorScene = ObjectAnimator()
    var groundBoxCollision = CGSize.zero
    var cameraNode = SKCameraNode()
    var chargingBox: ChargingBox?
    var winBox = WinBox(numberOfKey: 0)
    var winBoxTriggerLevettaSpown: SKNode!
    var gate = Gate(sprite: SKSpriteNode(imageNamed: ""))
    // LIGHT && color
    var _scale: CGFloat = 1.0
    var _screenH: CGFloat = 640.0
    var _screenW: CGFloat = 960.0
    var backgroundGameScene1 = SetupMap()
    var backgroundGameScene2 = SetupMap()
//    var _backgroundSprite1: SKSpriteNode?
//    var _backgroundSprite2: SKSpriteNode?
//    var _foregroundSprite2: SKSpriteNode?
    var lightSprite: SKSpriteNode?
    var nearWinBox = false
    var winBoxSpown: SKNode!
    
    // INPUT
    var playerController: PlayerController = PlayerController(touchLeft: SKSpriteNode(imageNamed: "freccia"), touchRight: SKSpriteNode(imageNamed: "freccia"), touchJump: SKSpriteNode(imageNamed: "Jump"), touchLightOnOff: SKSpriteNode(imageNamed: "LightButton"))
    
    var playerPosx: CGFloat = 0
    
    enum NodesZPosition: CGFloat {
      case joystick
    }
    
    lazy var analogJoystick: AnalogJoystick = {
      let js = AnalogJoystick(diameter: 160, colors: nil, images: (substrate: #imageLiteral(resourceName: "jSubstrate"), stick: #imageLiteral(resourceName: "jStick")))
        js.position = CGPoint(x: self.frame.size.width * -0.5 + js.radius + 45, y: self.frame.size.height * -0.5 + js.radius + 45)
        js.zPosition = NodesZPosition.joystick.rawValue
        return js
    }()

    
    override func sceneDidLoad() {
        player = Player(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 100, height: 100), scene: self, progressBar: progressBar)
        //        setupItem()
        setupWinBox()
        addChild(player.timerNode)

    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        // Camera
        camera = cameraNode
        addChild(cameraNode)
        floppyDisk1.sprite.position.x = player.sprite.position.x + 100
        floppyDisk1.sprite.position.y = player.sprite.position.y
        addChild(floppyDisk1.sprite)
        // GESTIONE LUCI
       _screenH = view.frame.height
       _screenW = view.frame.width
       _scale = _screenW / 3800
        initGround()
        
        blackBackground = self.childNode(withName: "blackBackground")
        blackBackground.zPosition = Utilities.ZIndex.background
        
        // VIDEO LOOP
       
        let videoNode: SKVideoNode? = {
                    let urlString = Bundle.main.path(forResource: "glitch", ofType: "mov")
                    let url = URL(fileURLWithPath: urlString!)
                    let item = AVPlayerItem(url: url)
                    avPlayer = AVPlayer(playerItem: item)
                    return SKVideoNode(avPlayer: avPlayer)
                }()

                videoNode?.position = CGPoint( x: frame.midX,
                                               y: frame.midY)
        videoNode?.zPosition = Utilities.ZIndex.layer1
                addChild((videoNode)!)

                avPlayer.play()

                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                                       object: avPlayer.currentItem, queue: nil)
                { notification in
                    self.avPlayer.seek(to: CMTime.zero)
                    self.avPlayer.play()
                }
        videoNode?.position = blackBackground.position
        videoNode?.size = blackBackground.frame.size
        
        // Joystick
        setupJoystick()
        progressBar.getSceneFrame(sceneFrame: frame)
        progressBar.buildProgressBar()
        addChild(progressBar)
        chargingBox = ChargingBox(scene: self, player: player)
        chargingBox?.sprite.position.x = player.sprite.position.x + 300
        chargingBox?.sprite.position.y = player.sprite.position.y - 50
        addChild(playerController.touchJump)
        addChild(playerController.touchLightOnOff)
        
//        addChild(video)
        video.position = blackBackground.position
        video.zPosition = Utilities.ZIndex.layer1
        video.size = blackBackground.frame.size

    }
    
    override func update(_ currentTime: TimeInterval)
    {

        // Called before each frame is rendered
        updatables.forEach{$0.update(currentTime: currentTime)}
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        deltaTime = dt

        self.lastUpdateTime = currentTime

        cameraNode.position.x = player.sprite.position.x
        cameraNode.position.y = player.sprite.position.y
        
        progressBar.progressFollowPlayer(player: player)
        
        playerController.touchJump?.position.x = cameraNode.position.x + 450
        playerController.touchJump?.position.y = cameraNode.position.y - 200

        analogJoystick.position.x = cameraNode.position.x - 460
        analogJoystick.position.y = cameraNode.position.y - 170

        playerController.touchLightOnOff?.position.x = cameraNode.position.x + 550
        playerController.touchLightOnOff?.position.y = cameraNode.position.y - 150
        
        player.light.lightSprite.position.x = player.sprite.position.x

//         Controllo per interrompere l'animazione di camminata dal JOYSTICK
        if(!joystickButtonClicked && !player.isFalling && !player.playerHit && !player.isCharging && !player.damageLight)
        {
            player.playerAnimator.startIdleAnimation(player: player)
        }
        
        if(player.time <= 0)
        {
            player.playerDeath()
        }
        
        if player.imDeathing
        {
            print("sto morendo")
            player.playerAnimator.startDeathAnimation(player: player)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if chooseVibration && !player.isCharging && !player.videoFloppyIsPlaying {
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            impactMed.impactOccurred()
        }
        let touch = touches.first!
        let location = touch.location(in: self)
           
                if(!player.isCharging && !player.videoFloppyIsPlaying)
                {
                    if(atPoint(location).name == "jump")
                    {
//                    player.sprite.removeAllActions()
                    // Caso in cui premo il bottone jump vicino alla boxCharge
                    if(player.nearBoxCharge && !player.videoFloppyIsPlaying && !player.nearFloppy)
                    {
                        if(!player.isCharging)
                        {
                            player.chargingPlayer()
                        }
                    }
                    // Quando effettivamente effettua il salto
                    if(!player.isFalling && !player.nearBoxCharge && player.canJump && !player.nearFloppy && !player.nearWinBox && !player.nearGate && !winBox.opened)
                    {
                        player.isJumping = true
                        player.isFalling = true
                        player.Jump()
                    }
                    
                    if(!player.nearBoxCharge && player.nearFloppy && !player.nearWinBox)
                    {
                        floppyDisk1.videoToPlay.position = CGPoint(x: player.sprite.position.x, y:player.sprite.position.y)
                        addChild(floppyDisk1.videoToPlay)
                        floppyDisk1.playFloppyVideo(scene: self, player: player, playerController: playerController)
                    }
                    if(!player.nearBoxCharge && !player.nearFloppy && player.nearWinBox)
                    {
                        winBox.chekOpenGate(player: player)
                    }
                    
                    if(player.nearGate && winBox.opened == true)
                    {
                        player.playerWin()
                    }
                }
                    else if(atPoint(location).name == "lightOnOff")
                    {
                        if(player.lightIsOn == false)
                        {
                            player.lightButtonClicked = true
                            player.lightIsOn = true
                            player.timerNode.isPaused = false
                            player.hitAfterTurnOnLight()
                        }
                        else
                        {
                            player.lightButtonClicked = false
                            player.lightIsOn = false
                            player.timerNode.isPaused = true
                        }
                        player.light.checkLightIsOnOff(player: player)
                    }

                
                else
                {
                    if(player.isCharging)
                    {
                        player.playerAnimator.startChargeAnimation(player: player)
                    }
                }
            }
        else if(player.videoFloppyIsPlaying)
        {
            player.videoPlay.videoToPlay.removeFromParent()
            if(player.videoPlay.currentvideo < self.player.videoPlay.videoName.count)
            {
                player.videoPlay.playFloppyVideo(scene: self, player: player, playerController: playerController)
                player.videoPlay.currentvideo += 1
                
            }
            else{
                player.videoPlay.backgroundVideoImage.removeFromParent()
                player.videoPlay.videoToPlay.removeFromParent()
                player.videoPlay.stopFloppyVideo(player: player, playerController: playerController)
                player.videoPlay = FloppyDisk(videoName: [])
            }
        }
        
    }
    
    //MARK: - didBegin
    func didBegin(_ contact: SKPhysicsContact)
    {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.node?.name == "player")
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "chargingBox")
        {
            secondBody.collisionBitMask = 0
            firstBody.contactTestBitMask = Utilities.CollisionBitMask.chargingBoxCategory
            playerController.touchJump.texture = SKTexture(imageNamed: "ChargeButton")
            player.nearBoxCharge = true
            player.canJump = false
//            player.sprite.removeAllActions()
        }
        
        if(firstBody.node?.physicsBody?.categoryBitMask == Utilities.CollisionBitMask.playerCategory || secondBody.node?.physicsBody?.categoryBitMask == Utilities.CollisionBitMask.groundCategory)
        {
            player.isFalling = false
            if joystickButtonClicked
            {
                player.playerAnimator.startRunningAnimation(player: player)
            }
        }
        
//        if(firstBody.node?.name == "player" && secondBody.node?.name == "item")
//        {
//            self.item.sprite.removeFromParent()
//        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "winBox")
        {
            player.nearWinBox = true
            print("HO FOTTUTAMENTE VINTO")
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "invisibleGroundFalling")
        {
//            player.sprite.removeAllActions()
//            analogJoystick.removeFromParent()
            player.playerDeath()
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "enemy")
        {
            player.time -= 5
//            player.lightIsOn = false
            player.playerHit = true
            player.canMove = false
            player.playerAnimator.startHitAnimation(player: player)
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "floppy")
        {
            player.canJump = false
            playerController.touchJump.texture = SKTexture(imageNamed: "mano")
            player.nearFloppy = true
            print(player.nearFloppy)
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "enemyView")
        {
            secondBody.collisionBitMask = 0
        }
        
       
        if(firstBody.node?.name == "player" && secondBody.node?.name == "invisibleWall")
        {
            
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "gate")
        {
            player.nearGate = true
        }
    }
    
    //MARK: - didEnd
    func didEnd(_ contact: SKPhysicsContact)
    {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if(contact.bodyA.node?.name == "player")
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "chargingBox")
        {
            secondBody.collisionBitMask = Utilities.CollisionBitMask.chargingBoxCategory
            firstBody.collisionBitMask = Utilities.CollisionBitMask.playerCategory
            firstBody.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
            playerController.touchJump.texture = SKTexture(imageNamed: "Jump")
            player.nearBoxCharge = false
            player.canJump = true
            
        }
        
        else if(firstBody.node?.name == "player" && secondBody.node?.name == "enemy")
        {
            player.playerHit = false
            player.playerAnimator.startIdleAnimation(player: player)
        }
    
        if(firstBody.node?.name == "player" && secondBody.node?.name == "floppy")
        {
            player.canJump = true
            playerController.touchJump.texture = SKTexture(imageNamed: "Jump")
            player.nearFloppy = false
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "winBox")
        {
            player.nearWinBox = false
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "gate")
        {
            player.nearGate = false
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "questItem")
        {
            secondBody.collisionBitMask = Utilities.CollisionBitMask.pickupItemCategory
        }
    }
}


extension Tutorial
{
    
    fileprivate func initGround()
    {
        for index in 0..<2
        {
            groundGameScene1.setupGround(scene: self, nameGround: "ground\(index)")
        }
    }
    
    //MARK: - setup JOYSTICK
    func setupJoystick()
    {
        // probabilmente l'if player can move dentro l'handler fa buggare la prima volta e lo rende scattoso vedere meglio
        analogJoystick.zPosition = Utilities.ZIndex.HUD
        addChild(analogJoystick)
        playerSpeed = CGPoint.zero
        analogJoystick.trackingHandler =
            {
                [unowned self] data in
                if player.canMove
                {
                    let newPosition = CGPoint(x: self.player.sprite.position.x + (data.velocity.x * self.player.velocityMultiplier),y: self.player.sprite.position.y)
                    self.player.sprite.position = newPosition
            
                    if joystickButtonClicked && !animRunning && !player.playerHit && !player.videoFloppyIsPlaying && !player.isCharging
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime)
                        {
                            print("I'm moving")
                            self.player.playerAnimator.startRunningAnimation(player: self.player)
                        }
                    }
                    if (data.velocity.x < 0)
                    {
                        self.player.sprite.xScale = -1
                    }
                    else
                    {
                        self.player.sprite.xScale = 1
                    }
                }
            }
        }
    
    //MARK: - setup WINBOX
    func setupWinBox()
    {
        winBox.sprite.size = CGSize(width: 50, height: 50)
        winBox.sprite.zPosition = Utilities.ZIndex.sceneObject
        winBox.sprite.physicsBody!.isDynamic = false
        winBox.sprite.physicsBody?.affectedByGravity = false
        winBox.sprite.position.y = player.sprite.position.y - 70
        winBox.sprite.position.x = player.sprite.position.x - 600
        winBox.sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.winBoxCategory
        winBox.sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        winBox.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        
        
        //SETUP GATE
//        winBox.setNumberOkKey(numberOfKey: 1)
//        questItem.setGUID(GUID: winBox.GUID)
        winBoxSpown = self.childNode(withName: "winBox")
        winBoxTriggerLevettaSpown = self.childNode(withName: "levetta")
        winBox.sprite.position = winBoxTriggerLevettaSpown.position
        winBoxTriggerLevettaSpown.isHidden = true
        winBox.setGate(gate: gate, position: winBoxSpown.position)
        
        //Secondo te è meglio winBox.AddChild(gate.sprite)
//        addChild(gate.sprite)
        
        addChild(winBox.sprite)
        addChild(winBox.gate.sprite)
//        bolt.sprite.position.x = player.sprite.position.x + 1000
//        bolt.sprite.position.y = player.sprite.position.y
//        addChild(bolt.sprite)
    }
}
