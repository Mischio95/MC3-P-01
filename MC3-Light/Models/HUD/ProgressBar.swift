//
//  ProgressBar.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 27/02/23.
//

import Foundation
import SpriteKit


class ProgressBar: SKNode
{
    private var progress = CGFloat(29)
    private var maxProgress = CGFloat(29)
    private var maxProgressBarWidth = CGFloat(0)
    var videoIsPlaying: Bool = false
    
    private var progressBar = SKSpriteNode()
    private var progressBarContainer = SKSpriteNode()
    
    private let progressTexture = SKTexture(imageNamed: "progressResize")
    private let progressTextureContainer = SKTexture(imageNamed: "hud vuoto")
    
    private var video = SKVideoNode(fileNamed: "fulmine.mov")
    
    private var sceneFrame = CGRect()
    
    private var playerProgressAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "ProgressBarFacePlayer")
    }
    
    private var playerIdleProgressAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "ProgressBarFacePlayer")
    }
    
    private var playerAnimProgressBar: [SKTexture]
    {
        return[playerProgressAtlas.textureNamed("PlayerProgressBarFace0"),
               playerProgressAtlas.textureNamed("PlayerProgressBarFace1"),
               playerProgressAtlas.textureNamed("PlayerProgressBarFace2"),
               playerProgressAtlas.textureNamed("PlayerProgressBarFace3"),
               playerProgressAtlas.textureNamed("PlayerProgressBarFace4"),
               playerProgressAtlas.textureNamed("PlayerProgressBarFace5")]
    }
    
    private var playerIdleAnimProgressBar: [SKTexture]
    {
        return[playerProgressAtlas.textureNamed("PlayerProgressBarFace0")]
    }
    
    var playerImage = SKSpriteNode(imageNamed: "PlayerProgressBarFace0")
    
    
    var boltHUDImage = SKSpriteNode(imageNamed: "bolt")
    var keyHUDImage = SKSpriteNode(imageNamed: "CardCounterHUD")
    
   
    
    override init() {
        super.init()
        self.progressBar.size = CGSize(width: 10, height: 10)
        self.progressBarContainer.size = CGSize(width: 10, height: 10)
        self.playerImage.size = CGSize(width: 90, height: 90)
        self.playerImage.position.x = progressBar.position.x - 80
        self.playerImage.position.y = progressBar.position.y
        self.playerImage.zPosition = Utilities.ZIndex.HUD
    }
    
    func getSceneFrame(sceneFrame: CGRect)
    {
        self.sceneFrame = sceneFrame
        maxProgressBarWidth = sceneFrame.width * 0.2
        print(sceneFrame)
    }
    
    func buildProgressBar()
    {
        progressBarContainer = SKSpriteNode(texture: progressTextureContainer, size:  progressTextureContainer.size())
        progressBarContainer.size.width = sceneFrame.width * 0.2
        progressBarContainer.size.height = sceneFrame.height * 0.05
        progressBarContainer.anchorPoint = CGPoint(x: 0, y: 0.5)

        progressBarContainer.zPosition = Utilities.ZIndex.HUD - 1

        progressBar = SKSpriteNode(texture: progressTexture, size: progressTexture.size())
        progressBar.size.width = sceneFrame.width * 0.2
        progressBar.size.height = sceneFrame.height * 0.047
        progressBar.position.x = -maxProgressBarWidth / 2
        progressBar.anchorPoint = CGPoint(x: 0, y: 0.5)
        progressBar.zPosition = Utilities.ZIndex.HUD
        
//        progressBar.addChild(video)
        //        updateColorBar()
        
        addChild(progressBar)
        addChild(progressBarContainer)
        addChild(playerImage)
    }
    
    func updateProgressBar(time: CGFloat)
    {
        if time <= 0 { return }
//        progressBar.run(SKAction.resize(toWidth: CGFloat( time / maxProgress) * maxProgressBarWidth, duration: 0.2))
        video.run(SKAction.resize(toWidth: CGFloat( time / maxProgress) * maxProgressBarWidth, duration: 0.2))
        
        if(!videoIsPlaying)
        {
            videoIsPlaying = true
            
            video = SKVideoNode(fileNamed: "fulmine.mov")
            video.size.width = progressBar.size.width
            video.size.height = progressBar.size.height
            video.anchorPoint = CGPoint(x: 0, y: 0.5)
            video.zPosition = Utilities.ZIndex.videoFloppy
            progressBar.run(SKAction.resize(toWidth: CGFloat( time / maxProgress) * maxProgressBarWidth, duration: 0.2))
            video.run(SKAction.resize(toWidth: CGFloat( time / maxProgress) * maxProgressBarWidth, duration: 0.2))
            progressBar.addChild(video)
            video.play()
           
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
            {
                self.video.removeFromParent()
                self.videoIsPlaying = false
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func progressFollowPlayer(player: Player)
    {
        progressBar.position.x = player.sprite.position.x - 450
        progressBar.position.y = player.sprite.position.y + 230
        progressBarContainer.position.x = player.sprite.position.x - 450
        progressBarContainer.position.y = player.sprite.position.y + 230
        playerImage.position.x = progressBar.position.x - 50
        playerImage.position.y = progressBar.position.y
    }
    
    func startPlayerAnimationProgressBar()
    {
        let startPlayerAnimationForProgress = SKAction.animate(with: playerAnimProgressBar, timePerFrame: 0.24)
        playerImage.run(SKAction.repeatForever(startPlayerAnimationForProgress), withKey: "PlayerAnimationProgressBar")
    }
    
    func startPlayerIdleAnimationProgressBar()
    {
        let startPlayerIdleAnimationForProgress = SKAction.animate(with: playerIdleAnimProgressBar, timePerFrame: 0.24)
        playerImage.run(SKAction.repeatForever(startPlayerIdleAnimationForProgress), withKey: "PlayerIdleAnimationProgressBar")
    }
    
    func updateColorBar()
    {
        progressBar.color = .red
        progressBar.colorBlendFactor = 1.0
    }
}
