//
//  FloppyAnimator.swift
//  MC3-Light
//
//  Created by Kiar on 03/03/23.
//

import Foundation
import SpriteKit

class FloppyAnimator
{
    private var floppyAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "Floppy")
    }
    
    private var floppyAnimations: [SKTexture]
    {
        return[floppyAtlas.textureNamed("00001"),
               floppyAtlas.textureNamed("00002"),
               floppyAtlas.textureNamed("00003"),
               floppyAtlas.textureNamed("00004"),
               floppyAtlas.textureNamed("00005"),
               floppyAtlas.textureNamed("00006"),
               floppyAtlas.textureNamed("00007"),
               floppyAtlas.textureNamed("00008"),
               floppyAtlas.textureNamed("00009"),
               floppyAtlas.textureNamed("00010"),
               floppyAtlas.textureNamed("00011"),
               floppyAtlas.textureNamed("00012"),
               floppyAtlas.textureNamed("00013")]
    }
    
    func startFloppyAnimation(sprite: SKSpriteNode)
    {
        let move = SKAction.animate(with: floppyAnimations, timePerFrame: 0.14)
        sprite.run(SKAction.repeatForever(move), withKey: "floppyAnimation")
    }
}

