//
//  Gate.swift
//  MC3-Light
//
//  Created by Kiar on 04/03/23.
//

import Foundation
import SpriteKit

class Gate
{
    var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "")
    
    init() {
        self.startIdleAnimation()
    }
    
    private var WinBoxAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "WinBox")
    }
    
    private var OpenAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("WinBox1"),
               WinBoxAtlas.textureNamed("WinBox2"),
               WinBoxAtlas.textureNamed("WinBox3"),
               WinBoxAtlas.textureNamed("WinBox4"),
               WinBoxAtlas.textureNamed("WinBox5")]
    }
    
    private var IdleAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("WinBox1")]
    }
    
    private var endAnimations: [SKTexture]
    {
        return[WinBoxAtlas.textureNamed("WinBox5")]
    }
        
    func startEndAnimation()
    {
        self.sprite = SKSpriteNode(imageNamed: "WinBox5")
        let move = SKAction.animate(with: endAnimations, timePerFrame: 0.14)
//        self.sprite.run(move)
    }
    
    func startOpengateAnimation()
    {
        let move = SKAction.animate(with: OpenAnimations, timePerFrame: 0.14)
        self.sprite.run(move)
//        self.sprite = SKSpriteNode(imageNamed: "WinBox5")
    }
    
    func startIdleAnimation()
    {
        let move = SKAction.animate(with: IdleAnimations, timePerFrame: 0.14)
        self.sprite.run(move)
    }
}
