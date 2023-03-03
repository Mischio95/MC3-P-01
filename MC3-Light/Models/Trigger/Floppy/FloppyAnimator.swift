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
               floppyAtlas.textureNamed("00013"),
               floppyAtlas.textureNamed("00014"),
               floppyAtlas.textureNamed("00015"),
               floppyAtlas.textureNamed("00016"),
               floppyAtlas.textureNamed("00017"),
               floppyAtlas.textureNamed("00018"),
               floppyAtlas.textureNamed("00019"),
               floppyAtlas.textureNamed("00020"),
               floppyAtlas.textureNamed("00021"),
               floppyAtlas.textureNamed("00022"),
               floppyAtlas.textureNamed("00023"),
               floppyAtlas.textureNamed("00024"),
               floppyAtlas.textureNamed("00025")]
    }
    
    func startFloppyAnimation(floppy: FloppyDisk)
    {
        let move = SKAction.animate(with: floppyAnimations, timePerFrame: 0.14)
        floppy.sprite.run(SKAction.repeatForever(move), withKey: "floppyAnimation")
    }
}

