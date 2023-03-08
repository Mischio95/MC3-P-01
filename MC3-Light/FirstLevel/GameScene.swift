//
//  GameScene.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 20/02/23.

//MARK: COSE CHE SI DEVONO O POTREBBERO FARE

// METTERE OGGETTO SCANNERIZZABILE PER TESTO CON IL TASTO ACTION
// Si potrebbe fare che se la luce sta accesa gli item pick sono visibili altrimenti no
// Creare scena per tutorial
// Creare pagina Settings e sistema di pausa
// Vedere in caso quali variabili salvare con lo userDefault tipo sound on off vibrazione ecc..
// Creare scena per winBox

//MARK: BUG DA FIXARE

// HUD Contatore

import SpriteKit
import GameplayKit
import GameController
import Foundation


class GameScene: SKScene, SKPhysicsContactDelegate
{
    var maschera: SKSpriteNode!
    var boltSpown  = SetupMap()
    var deltaTime: Double!
    let light2 = SKLightNode()
    var normalPlayerTexture : SKTexture?
    var playerTexture: SKTexture?
    var groundBoxCollision = CGSize.zero
    var player: Player!
    var playerStart : SKSpriteNode!
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var background: SKSpriteNode!
    var progressBar = ProgressBar()
    var objectAnimator = WaterPipe()
    var objectAnimatorScene = ObjectAnimator()
    var bottonClicked = true
    var nearWinBox = false
    var winBoxSpown: SKNode!
    
    let boltScore = SKLabelNode (fontNamed:"Copperplate-Bold")
    let boltHUDImage = SKSpriteNode(imageNamed: "bolt1")
    let keyCount = SKLabelNode (fontNamed:"Copperplate-Bold")
    let keyCountHUDImage = SKSpriteNode(imageNamed: "CardCounterHUD")
    
    private var updatables = [Updatable]()
    
    var cameraNode = SKCameraNode()
    
    var floppyDisk1 = FloppyDisk(videoName: ["floppy-1.mov"])
    
    var gameBackground = SetupMap()
    
    
    private var lastUpdateTime : TimeInterval = 0
  
    var questItem = PickupItem(sprite: SKSpriteNode(imageNamed: "Floppy_disk"), size: CGSize(width: 50, height: 50), quantity: 1)
    
        var bolt = Bolt(quantity: 1)
    
    
    
    // TRIGGER

    var chargingBox: ChargingBox!
    var winBox = WinBox(numberOfKey: 1)
    var winBoxTriggerLevettaSpown: SKNode!
    var chargingBoxSpown1: SKNode!
    var chargingBoxSpown2: SKNode!
    var chargingBoxSpownVector: [SKNode] = []
    
    
    // GROUND
    var groundGameScene1 = SetupMap()
    var invisibleGroundGameScene1 = SetupMap()
    
    // ENEMY
    var enemy = Enemy(sprite: SKSpriteNode(imageNamed: "enemyAnim1"), size: CGSize(width: 230, height: 100))
    var rangedEnemy = RangedEnemy(sprite: SKSpriteNode(imageNamed: "enemyAnim1"), size: CGSize(width: 50, height: 50))
    var enemySpownPosition : SKNode!
    
    var gate = Gate(sprite: SKSpriteNode(imageNamed: ""))
    var merchant: Merchant!
    var merchantSpown: SKNode!
    
    
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
    
    //MARK: - sceneDidLoad
    override func sceneDidLoad()
    {
        maschera = SKSpriteNode(imageNamed: "maschera.png")
//        addChild(maschera)
        maschera.size = CGSize(width: 1920, height: 1080)
        merchant = Merchant(scene: self)
        joystickButtonClicked = false
        animRunning = false
        player = Player(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 100, height: 100), scene: self, progressBar: progressBar)
        maschera.zPosition = player.sprite.zPosition + 1
        objectAnimator.setupAnimatorWaterFall(scene: self, player: player)
        enemySpownPosition = self.childNode(withName: "enemySpownPosition") // as? SKSpriteNode
        enemySpownPosition.isHidden = true
        self.lastUpdateTime = 0
        
        // setup - Ground and Invisible Ground

//        setupItem()
        setupWinBox()
       
        player.timerNode.isHidden = true
        addChild(playerController.touchJump)
        addChild(playerController.touchLightOnOff)
        updatables.append(enemy)
        addChild(player.timerNode)
    }
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        
       
//        self.physicsWorld.gravity = CGVectorMake(0, -30)
        self.physicsWorld.contactDelegate = self
        
        boltHUDImage.zPosition = Utilities.ZIndex.HUD
        boltHUDImage.size = CGSize(width: 50, height: 50)
       
        
        boltScore.fontSize = 30
        boltScore.fontColor = .white
        boltScore.zPosition = 1
        boltScore.position.x = frame.midX
        boltScore.position.y = frame.midY + 50
        boltScore.text = "\(player.inventory.boltAmount)"
        boltScore.zPosition = Utilities.ZIndex.HUD
        
        
        keyCountHUDImage.zPosition = Utilities.ZIndex.HUD
        keyCountHUDImage.size = CGSize(width: 30, height: 30)
       
        
        keyCount.fontSize = 30
        keyCount.fontColor = .white
        keyCount.zPosition = 1
        keyCount.position.x = frame.midX
        keyCount.position.y = frame.midY + 50
        keyCount.text = "\(player.inventory.keyAmount)"
        keyCount.zPosition = Utilities.ZIndex.HUD
       
        
        
        joystickButtonClicked = false
        animRunning = false
        
        // Camera
        camera = cameraNode
        addChild(cameraNode)
        addChild(merchant.sprite)
        
        
//        merchant.sprite.position.x = player.sprite.position.x + 700
//        merchant.sprite.position.y = player.sprite.position.y + 10
        
        // VIDEO TUTORIAL
        
        floppyDisk1.sprite.position.x = player.sprite.position.x - 100
        floppyDisk1.sprite.position.y = player.sprite.position.y 
//        addChild(floppyDisk1.sprite)
        
        // GESTIONE LUCI
       _screenH = view.frame.height
       _screenW = view.frame.width
       _scale = _screenW / 3800
        
        initGround()
        initBackground()
        initGasObjectScene()
        initWaterGreenScene()
        initBoltSpown()
//        initChargeBox()
        
        player.light.lightSprite.position.y = player.sprite.position.y + 50
        player.light.lightSprite.position.x = player.sprite.position.x
        
        if(player.lightIsOn)
        {
            player.timerNode.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(player.countdownPlayerPointLightBattery),SKAction.wait(forDuration: 1)])))
        }
        
        // Joystick
        setupJoystick()
        
        // Progress Bar
        
        progressBar.getSceneFrame(sceneFrame: frame)
        progressBar.buildProgressBar()
        addChild(progressBar)
        
        enemy.setupSprite(scene: self)
              
        //pickup
        addChild(questItem.sprite)
        questItem.floppyAnimator.startFloppyAnimation(sprite: questItem.sprite)
        questItem.sprite.position.x = player.sprite.position.x + 200
        questItem.sprite.position.y = player.sprite.position.y + 50
        
        chargingBoxSpown1 = self.childNode(withName: "chargeBoxSpown0")
        chargingBoxSpown1.isHidden = true
        chargingBox = ChargingBox(scene: self, player: player)
        chargingBox.sprite.position = chargingBoxSpown1.position
        addChild(boltScore)
        addChild(boltHUDImage)
        addChild(keyCountHUDImage)
        addChild(keyCount)
        
    }

    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if chooseVibration && !player.isCharging && !player.videoFloppyIsPlaying {
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            impactMed.impactOccurred()
        }
        let touch = touches.first!
        let location = touch.location(in: self)
            if(atPoint(location).name == "jump")
            {
                if(!player.isCharging && !player.videoFloppyIsPlaying)
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
                        floppyDisk1.videoToPlay.zPosition = 100
                        addChild(floppyDisk1.videoToPlay)
    //                    floppyDisk1.videoToPlay.play()
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
                
                else
                {
                    if(player.isCharging)
                    {
                        player.playerAnimator.startChargeAnimation(player: player)
                    }
                }
            }
            
            if(atPoint(location).name == "lightOnOff")
            {
                if(player.lightIsOn == false)
                {
                    player.lightButtonClicked = true
                    player.lightIsOn = true
                    player.timerNode.isPaused = false
//                    player.playerAnimator.resetAnimationAfterTurnOnLight(player: player)
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
//        }
    }
    
    //MARK: - touchesEnded
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5)
//        {
//            self.player.canMove = true
//        }
    }
    
    
    //MARK: - UPDATE
    override func update(_ currentTime: TimeInterval)
    {

        // Called before each frame is rendered
        updatables.forEach{$0.update(currentTime: currentTime)}
        
        boltHUDImage.position.x = player.sprite.position.x + 450
        boltHUDImage.position.y = player.sprite.position.y + 230
        
        boltScore.position.x = boltHUDImage.position.x + 40
        boltScore.position.y = boltHUDImage.position.y - 10
        
        keyCountHUDImage.position.x =  boltScore.position.x + 60
        keyCountHUDImage.position.y = boltScore.position.y
        
        keyCount.position.x =  boltScore.position.x + 100
        keyCount.position.y = boltScore.position.y
        
        
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
        
        maschera.position = cameraNode.position
        
        progressBar.progressFollowPlayer(player: player)
        playerController.touchJump?.position.x = cameraNode.position.x + 450
        playerController.touchJump?.position.y = cameraNode.position.y - 200

        analogJoystick.position.x = cameraNode.position.x - 460
        analogJoystick.position.y = cameraNode.position.y - 170

        playerController.touchLightOnOff?.position.x = cameraNode.position.x + 550
        playerController.touchLightOnOff?.position.y = cameraNode.position.y - 150
        
        player.light.lightSprite.position.x = player.sprite.position.x

//        light2.falloff = light.falloff
        
        if player.lightIsOn
        {
            lightSprite?.position.y = player.sprite.position.y + 50
            maschera.isHidden = true
        }
        else
        {
            maschera.isHidden = false
        }
        
        
        if(player.lightIsOn && !player.videoFloppyIsPlaying && !player.isCharging)
        {
            if(!enemy.isInLife)
            {
                enemy.spawnEnemy(scene: self)
            }
            
            enemy.enemyFollowThePlayer(player: player)
        }
        else
        {
            enemy.sprite.position = enemySpownPosition.position
        }
        
        
        // COSI SE IL NEMICO E' NELLA BASE DI RICARICA ED E' INVISIBILE PURE SE IL PLAYER CI PASSA SOPRA NON PRENDE DANNO
        if enemy.sprite.position == enemySpownPosition.position
        {
            enemy.sprite.isHidden = true
            enemy.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.enemyCategory
        }
        else
        {
            enemy.sprite.isHidden = false
            enemy.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        }

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
        
        if !player.lightIsOn
        {
            if(questItem.isInLife)
            {
                questItem.isInLife = false
                questItem.sprite.removeFromParent()
            }
        }
        else
        {
            if(!questItem.isInLife)
            {
                questItem.isInLife = true
                addChild(questItem.sprite)
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
            enemy.isAtacking = true
            player.playerHit = true
            player.canMove = false
            player.playerAnimator.startHitAnimation(player: player)
            enemy.despawnEnemy(player: player)
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "floppy")
        {
            player.canJump = false
            playerController.touchJump.texture = SKTexture(imageNamed: "mano")
            player.nearFloppy = true
            print(player.nearFloppy)
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "soundTrigger")
        {
            print("contact")
            if(objectAnimator.isPlaying)
            {
                print("if")
                objectAnimator.soundToPlay.removeFromParent()
            }
            else
            {
                print("else")
                addChild(objectAnimator.soundToPlay)
                
            }
            print("esco")
            objectAnimator.handlerPlaySound(scene: self)
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "enemyView")
        {
            secondBody.collisionBitMask = 0
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "questItem")
        {
//            secondBody.collisionBitMask = 0
//            if(player.lightIsOn)
//            {
//                player.inventory.addItemInInventory(itemToAdd: questItem)
//            }
            secondBody.node?.removeFromParent()
            player.inventory.addKey()
            keyCount.text = "\(player.inventory.keyAmount)"
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "bolt")
        {
            secondBody.node?.removeFromParent()
            player.inventory.addBoltsInInventory()
            boltScore.text = "\(player.inventory.boltAmount)"
            
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "merchant")
        {
            merchant.Talking()
            print("ciao")
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
        if(firstBody.node?.name == "player" && secondBody.node?.name == "merchant")
        {
            print("end")
            merchant.Talking()
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "gate")
        {
            player.nearGate = false
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "questItem")
        {
//            secondBody.collisionBitMask = Utilities.CollisionBitMask.pickupItemCategory
            player.inventory.addKey()
            secondBody.node?.removeFromParent()
        }
    }
}

// ------------------------------------------ MARK: - EXTENSION LUCI E JOYSTICK ----------------------------------------------------------------

extension GameScene
{
    
    fileprivate func initBoltSpown()
    {
        for index in 0...77
        {
            boltSpown.setupBolt(scene: self, nameBackground: "bolt\(index)")
           
        }
    }
    
    fileprivate func initBackground()
    {
        backgroundColor = SKColor.black
        
        for index in 0..<2
        {
            backgroundGameScene1.setupBackground(scene: self, nameBackground: "backgroundGrandeSfondo\(index)")
        }
    }
    
    fileprivate func initGround()
    {
        invisibleGroundGameScene1.setupInvisibleGroundForFalling(scene: self, nameGround: "invisibleFallingCollision")
        
        for index in 0..<25
        {
            groundGameScene1.setupGround(scene: self, nameGround: "ground\(index)")
        }
    }
    
    fileprivate func initGasObjectScene()
    {
//        for index in 0..<2
//        {
//            objectAnimatorScene.setupAnimatorGas(scene: self, nodeNameInTheScene: "gas\(index)")
//        }
    }
    
    fileprivate func initWaterGreenScene()
    {
//        for index in 0..<4
//        {
//            objectAnimatorScene.setupAnimatorWaterGreen(scene: self, nodeNameInTheScene: "acquaVerde\(index)")
//        }
    }
    
    fileprivate func initWater()
    {
//        for index in 0..<5
//        {
//            objectAnimatorScene.setupAnimatorWaterGreen(scene: self, nodeNameInTheScene: "water\(index)")
//        }
    }
    
    func EnemyShoot()
    {
        let bullet = Bullet(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 0.5, height: 0.5))
        bullet.sprite.size = CGSize(width: 5, height: 5)
        addChild(bullet.sprite)
        rangedEnemy.shooting(bullet: bullet, player: player.sprite)
    }
    // fa index out of range
    
//   fileprivate func initChargeBox()
//    {
//        chargingBoxSpown1 = scene?.childNode(withName: "chargeBoxSpown1")
//        chargingBoxSpown2 = scene?.childNode(withName: "chargeBoxSpown2")
//
//        chargingBoxSpownVector.append(chargingBoxSpown1)
//        chargingBoxSpownVector.append(chargingBoxSpown2)
//
//        for index in 0..<chargingBoxSpownVector.count
//        {
//            chargingBoxSpownVector[index].isHidden = true
//            chargingBox[index].sprite.position = chargingBoxSpownVector[index].position
//        }
//    }
}

// ------------------------------------------ MARK: - EXTENSION PER I VARI SETUP ----------------------------------------------------------------

extension GameScene
{
    

    
    //MARK: - setup WINBOX
    func setupWinBox()
    {
        winBox.sprite.size = CGSize(width: 50, height: 50)
        winBox.sprite.zPosition = player.sprite.zPosition
        winBox.sprite.physicsBody!.isDynamic = false
        winBox.sprite.physicsBody?.affectedByGravity = false
        winBox.sprite.position.y = player.sprite.position.y - 70
        winBox.sprite.position.x = player.sprite.position.x - 600
        winBox.sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.winBoxCategory
        winBox.sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        winBox.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        winBox.sprite.zPosition = player.sprite.zPosition - 1
        
        
        //SETUP GATE
//        winBox.setNumberOkKey(numberOfKey: 1)
        questItem.setGUID(GUID: winBox.GUID)
        winBoxSpown = self.childNode(withName: "winBox")
        winBoxTriggerLevettaSpown = self.childNode(withName: "levetta")
        winBox.sprite.position = winBoxTriggerLevettaSpown.position
        winBoxTriggerLevettaSpown.isHidden = true
        winBox.setGate(gate: gate, position: winBoxSpown.position)
        
        //Secondo te è meglio winBox.AddChild(gate.sprite)
//        addChild(gate.sprite)
        
        addChild(winBox.sprite)
        addChild(winBox.gate.sprite)
        bolt.sprite.position.x = player.sprite.position.x + 100
        bolt.sprite.position.y = player.sprite.position.y
        addChild(bolt.sprite)
    }
    
    //MARK: - setup JOYSTICK
    func setupJoystick()
    {
        // probabilmente l'if player can move dentro l'handler fa buggare la prima volta e lo rende scattoso vedere meglio
        analogJoystick.zPosition = 20
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
    }

/*
    fileprivate func addBackgroundTile(spriteFile: String) -> SKSpriteNode
    {
        var background:SKSpriteNode

        background = SKSpriteNode(imageNamed:spriteFile);
        background.color = _ambientColor!
        background.colorBlendFactor = 1
        background.zPosition = -1
        background.alpha = 1
        background.anchorPoint = CGPoint(x:0, y:0.5)
        background.setScale(_scale)
        addChild(background);

        return background;
    }
    
    fileprivate func addForegroundTile(spriteFile: String, normalsFile: String) -> SKSpriteNode
    {
        var foreground:SKSpriteNode
        
        foreground = SKSpriteNode(texture: SKTexture(imageNamed:spriteFile), normalMap: SKTexture(imageNamed:normalsFile));
        foreground.lightingBitMask = 1
        foreground.color = _ambientColor!
        foreground.colorBlendFactor = 1
        foreground.zPosition = -1
        foreground.anchorPoint = CGPoint(x:0.5, y:0.5)
        foreground.setScale(_scale * 2)
        foreground.zPosition = player.sprite.zPosition - 10
        addChild(foreground)
        return foreground
    }
*/
