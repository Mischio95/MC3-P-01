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

// FIXARE CHE SE SUBISCO DANNO DA ACCENSIONE LUCE NON PARTE LA HITANIM DEL PLAYER SE STO FERMO MA SE CAMMINO SI, E POI FIN QUANDO NON MI FERMO NON SI STOPPA
// CHARG BOX
// AMBIENT DAMAGE
// RIMETTERE MATERIALE DI FEDE PER HIT
// FIXARE JUMP
// INSERIRE ALTRI TRIGGER PER ALTRI SUONI ED OGETTI DI BACKGROUND
// SPAWN POINT PER ENEMY

import SpriteKit
import GameplayKit
import GameController
import Foundation


class GameScene: SKScene, SKPhysicsContactDelegate
{
    var deltaTime: Double!
    let light = SKLightNode()
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
    
    private var updatables = [Updatable]()
    
    var cameraNode = SKCameraNode()
    
    var floppyDisk1 = FloppyDisk(sprite: SKSpriteNode(imageNamed: "Floppy_disk"), size: CGSize(width: 50, height: 50), videoToPlay: SKVideoNode(fileNamed: "floppy-1.mov"))
    
    var gameBackground = SetupMap()
    
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
        
    
    // TRIGGER
//    var bullet = Bullet(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 15, height: 15))
    var chargingBox = ChargingBox(sprite: SKSpriteNode(imageNamed: "base_ricarica"), size: CGSize(width: 18, height: 18))
    var item = Item(sprite: SKSpriteNode(imageNamed: "item"), size: CGSize(width: 50, height: 50))
    var winBox = WinBox(sprite: SKSpriteNode(imageNamed: "WinBox"), size: CGSize(width: 50, height: 50))
    
    // GROUND
    var groundGameScene1 = SetupMap()
    var invisibleGroundGameScene1 = SetupMap()
    
    // ENEMY
    var enemy = Enemy(sprite: SKSpriteNode(imageNamed: "enemyAnim1"), size: CGSize(width: 230, height: 100))
    var rangedEnemy = RangedEnemy(sprite: SKSpriteNode(imageNamed: "enemyAnim1"), size: CGSize(width: 50, height: 50))
    var enemySpownPosition : SKNode!
    
    // LIGHT && color
    var _scale: CGFloat = 1.0
    var _screenH: CGFloat = 640.0
    var _screenW: CGFloat = 960.0
    var backgroundGameScene1 = SetupMap()
    var backgroundGameScene2 = SetupMap()
//    var _backgroundSprite1: SKSpriteNode?
//    var _backgroundSprite2: SKSpriteNode?
//    var _foregroundSprite2: SKSpriteNode?
    var _ambientColor: UIColor?
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
        joystickButtonClicked = false
        animRunning = false
        player = Player(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 100, height: 100), scene: self, progressBar: progressBar, light: light)
        objectAnimator.setupAnimatorWaterFall(scene: self, player: player)
        enemySpownPosition = self.childNode(withName: "enemySpownPosition") // as? SKSpriteNode
        enemySpownPosition.isHidden = true
        self.lastUpdateTime = 0
        
        // setup - Ground and Invisible Ground

        setupChargingBox()
        setupItem()
        setupWinBox()
       
        player.timerNode.isHidden = true
        addChild(playerController.touchJump)
        addChild(playerController.touchLightOnOff)
        updatables.append(enemy)
        addChild(player.timerNode)
    }
    
    //MARK: - didMove
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        joystickButtonClicked = false
        animRunning = false
        
        // Camera
        camera = cameraNode
        addChild(cameraNode)
        
        // VIDEO TUTORIAL
        
        floppyDisk1.sprite.position.x = player.sprite.position.x - 100
        floppyDisk1.sprite.position.y = player.sprite.position.y 
        addChild(floppyDisk1.sprite)
        
        // GESTIONE LUCI
       _screenH = view.frame.height
       _screenW = view.frame.width
       _scale = _screenW / 3800
        
       _ambientColor = UIColor.darkGray
       initGround()
       initBackground()
       initLight()
       initGasObjectScene()
       initWaterGreenScene()
       lightSprite?.position.y = player.sprite.position.y + 50
       lightSprite?.position.x = player.sprite.position.x
        
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
    }

    //MARK: - touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if chooseVibration {
            let impactMed = UIImpactFeedbackGenerator(style: .soft)
            impactMed.impactOccurred()
        }
        let touch = touches.first!
        let location = touch.location(in: self)
            if(atPoint(location).name == "jump")
            {
                // Caso in cui premo il bottone jump vicino alla boxCharge
                if(player.nearBoxCharge)
                {
                    if(!player.isCharging)
                    {
                        player.chargingPlayer()
                    }
                }
                // Quando effettivamente effettua il salto
                if(!player.isFalling && !player.nearBoxCharge && player.canJump && !player.nearFloppy)
                {
                    player.isJumping = true
                    player.isFalling = true
                }
                
                if(player.nearFloppy)
                {
                    floppyDisk1.videoToPlay.position = CGPoint(x: player.sprite.position.x, y:player.sprite.position.y)
                    floppyDisk1.videoToPlay.zPosition = 100
                    addChild(floppyDisk1.videoToPlay)
//                    floppyDisk1.videoToPlay.play()
                    floppyDisk1.playFloppyVideo(scene: self, player: player, playerController: playerController)
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
                checkLightIsOnOff()
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
        
        lightSprite?.position.x = player.sprite.position.x

//        light2.falloff = light.falloff
        
        if(player.lightIsOn && !player.videoFloppyIsPlaying && !player.isCharging)
        {
            if(!enemy.isInLife)
            {
                enemy.spawnEnemy(scene: self)
            }
            
            lightSprite?.position.y = player.sprite.position.y + 50
            
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
        
        if(player.isJumping)
        {
//            player.maxJump = 220
            player.sprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: Int(player.maxJump)))
            player.playerAnimator.startJumpAnimation(player: player)
            DispatchQueue.main.asyncAfter(deadline: .now() + deltaTime)
            {
                self.player.isJumping = false
            }
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
            print("contact")
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "ground")
        {
            player.isFalling = false
            if joystickButtonClicked
            {
                player.playerAnimator.startRunningAnimation(player: player)
            }
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "item")
        {
            self.item.sprite.removeFromParent()
        }
        
        if(firstBody.node?.name == "player" && secondBody.node?.name == "winBox")
        {
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
//            secondBody.collisionBitMask = 0
//            firstBody.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
            player.canJump = false
            playerController.touchJump.texture = SKTexture(imageNamed: "ChargeButton")
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
//            enemy.isChasingPlayer = true
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
            print("contact")
        }
        
        else if(firstBody.node?.name == "player" && secondBody.node?.name == "enemy")
        {
            player.playerHit = false
            player.playerAnimator.startIdleAnimation(player: player)
        }
        
        else if(firstBody.node?.name == "player" && secondBody.node?.name == "enemyView")
        {
            secondBody.collisionBitMask = Utilities.CollisionBitMask.enemyViewCategory
            firstBody.collisionBitMask = Utilities.CollisionBitMask.playerCategory
            firstBody.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
//            touchJump.texture = SKTexture(imageNamed: "jump")
//            player.nearBoxCharge = false
            print("i don't see you")
//            enemy.isChasingPlayer = false
        }
        if(firstBody.node?.name == "player" && secondBody.node?.name == "floppy")
        {
            player.canJump = true
            playerController.touchJump.texture = SKTexture(imageNamed: "Jump")
            player.nearFloppy = false
        }
    }
}

// ------------------------------------------ MARK: - EXTENSION LUCI E JOYSTICK ----------------------------------------------------------------

extension GameScene
{
    
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
        
        for index in 0..<22
        {
            groundGameScene1.setupGround(scene: self, nameGround: "ground\(index)")
        }
       
        
    }
    
    fileprivate func initGasObjectScene()
    {
        for index in 0..<4
        {
            objectAnimatorScene.setupAnimatorGas(scene: self, nodeNameInTheScene: "gas\(index)")
        }
    }
    
    fileprivate func initWaterGreenScene()
    {
        for index in 0..<8
        {
            objectAnimatorScene.setupAnimatorWaterGreen(scene: self, nodeNameInTheScene: "acquaVerde\(index)")
        }
    }
    
    fileprivate func initWater()
    {
        for index in 0..<5
        {
            objectAnimatorScene.setupAnimatorWaterGreen(scene: self, nodeNameInTheScene: "water\(index)")
        }
    }
    
    //MARK: Light
    fileprivate func initLight() {
        lightSprite = SKSpriteNode(imageNamed: "lightbulb.png")
        lightSprite?.setScale(_scale * 50)
        lightSprite?.position = CGPoint(x: _screenW - 100, y: _screenH - 100)
        lightSprite?.size = CGSize(width: 0.1, height: 0.1)
        addChild(lightSprite!)

        light.position = .zero
        light.falloff = 0.1
        light.ambientColor = _ambientColor!
        light.lightColor = .white
        
        // ADD OTHER LIFE FOR UPGRADE INTENSITY LIGHT
        light2.position = .zero
        light2.falloff = 1
        light2.ambientColor = _ambientColor!
        light2.lightColor = .red
        
        lightSprite?.addChild(light)
//        lightSprite?.addChild(light2)
    }
    
    func checkLightIsOnOff()
    {
        if(player.lightIsOn)
        {
            self.lightSprite?.position.y = self.player.sprite.position.y + 50
        }
        else
        {
            self.lightSprite?.position.y = self.player.sprite.position.y + 3000

        }
    }
    
    func EnemyShoot()
    {
        let bullet = Bullet(sprite: SKSpriteNode(imageNamed: "Player"), size: CGSize(width: 0.5, height: 0.5))
        bullet.sprite.size = CGSize(width: 5, height: 5)
        addChild(bullet.sprite)
        rangedEnemy.shooting(bullet: bullet, player: player.sprite)
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
}

// ------------------------------------------ MARK: - EXTENSION PER I VARI SETUP ----------------------------------------------------------------

extension GameScene
{
    
    //MARK: - setup CHARGING BOX
    func setupChargingBox()
    {
        chargingBox.sprite.size = CGSize(width: 220, height: 60)
        chargingBox.sprite.zPosition = player.sprite.zPosition - 1
        chargingBox.sprite.physicsBody!.isDynamic = true
        chargingBox.sprite.position.y = player.sprite.position.y - 100
        chargingBox.sprite.position.x = player.sprite.position.x - 300
        chargingBox.sprite.lightingBitMask = 1
        chargingBox.sprite.physicsBody!.categoryBitMask = Utilities.CollisionBitMask.chargingBoxCategory
        chargingBox.sprite.physicsBody!.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        chargingBox.sprite.physicsBody?.affectedByGravity = false
        chargingBox.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
        addChild(chargingBox.sprite)
    }
    
    //MARK: - setup ITEM
    func setupItem()
    {
        item.sprite.size = CGSize(width: 200, height: 200)
        item.sprite.zPosition = player.sprite.zPosition + 6
        item.sprite.physicsBody!.isDynamic = true
        item.sprite.position.y = player.sprite.position.y
        item.sprite.position.x = player.sprite.position.x + 400
        item.sprite.physicsBody!.categoryBitMask = Utilities.CollisionBitMask.itemCatecory
        item.sprite.physicsBody!.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        item.sprite.physicsBody?.affectedByGravity = false
        item.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
//        addChild(item.sprite)
    }
    
    //MARK: - setup WINBOX
    func setupWinBox()
    {
        winBox.sprite.size = CGSize(width: 100, height: 100)
        winBox.sprite.zPosition = player.sprite.zPosition
        winBox.sprite.physicsBody!.isDynamic = false
        winBox.sprite.physicsBody?.affectedByGravity = false
        winBox.sprite.position.y = player.sprite.position.y - 100
        winBox.sprite.position.x = player.sprite.position.x + 600
        winBox.sprite.physicsBody?.categoryBitMask = Utilities.CollisionBitMask.winBoxCategory
        winBox.sprite.physicsBody?.collisionBitMask = Utilities.CollisionBitMask.playerCategory
        winBox.sprite.physicsBody?.contactTestBitMask = Utilities.CollisionBitMask.playerCategory
//        addChild(winBox.sprite)
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
            
                    if joystickButtonClicked && !animRunning && !player.playerHit
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

