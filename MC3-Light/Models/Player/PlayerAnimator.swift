//
//  PlayerAnimator.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 27/02/23.
//

import Foundation
import SpriteKit

class PlayerAnimator
{
        
    private var playerJumpAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "Player Jump")
    }
    
    private var playerIdleAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "PlayerWalking")
    }
    
    private var playerAnimAtlasWalking: SKTextureAtlas
    {
        return SKTextureAtlas(named: "PlayerWalking")
    }
    
    private var playerHitAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "PlayerHit")
    }
    
    private var playerAnimMove: [SKTexture]
    {
        return[playerAnimAtlasWalking.textureNamed("PlayerWalking2"),
               playerAnimAtlasWalking.textureNamed("PlayerWalking1"),
               playerAnimAtlasWalking.textureNamed("PlayerWalking3"),
               playerAnimAtlasWalking.textureNamed("PlayerWalking4"),
               playerAnimAtlasWalking.textureNamed("PlayerWalking5")]
    }
    
    private var playerIdleAnimation: [SKTexture]
    {
        return[playerAnimAtlasWalking.textureNamed("PlayerWalking1")]
    }
    
    private var playerAnimJump: [SKTexture]
    {
        return[playerJumpAtlas.textureNamed("PlayerJump1"),
               playerJumpAtlas.textureNamed("PlayerJump2"),
               playerJumpAtlas.textureNamed("PlayerJump3"),
               playerJumpAtlas.textureNamed("PlayerJump4"),
               playerJumpAtlas.textureNamed("PlayerJump5"),
               playerJumpAtlas.textureNamed("PlayerJump6"),
               playerJumpAtlas.textureNamed("PlayerJump7")]
    }
    
    
    private var playerAnimHit: [SKTexture]
    {
        return[playerHitAtlas.textureNamed("Robot_danno_1"),
               playerHitAtlas.textureNamed("Robot_danno_2"),
               playerHitAtlas.textureNamed("Robot_danno_3"),
               playerHitAtlas.textureNamed("Robot_danno_4"),
               playerHitAtlas.textureNamed("Robot_danno_5")]
    }
    
    
    private var playerDeathAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "PlayerDeath")
    }
    
    private var playerDeathAnimation: [SKTexture]
    {
        return[playerDeathAtlas.textureNamed("PlayerDeath1"),
               playerDeathAtlas.textureNamed("PlayerDeath2"),
               playerDeathAtlas.textureNamed("PlayerDeath3"),
               playerDeathAtlas.textureNamed("PlayerDeath4"),
               playerDeathAtlas.textureNamed("PlayerDeath5"),
               playerDeathAtlas.textureNamed("PlayerDeath6"),
               playerDeathAtlas.textureNamed("PlayerDeath7"),
               playerDeathAtlas.textureNamed("PlayerDeath8")]
    }
    
    private var playerChargeAtlas: SKTextureAtlas
    {
        return SKTextureAtlas(named: "PlayerCharge")
    }
    
    private var playerChargeAnimation: [SKTexture]
    {
        return[playerChargeAtlas.textureNamed("PlayerCharge1"),
               playerChargeAtlas.textureNamed("PlayerCharge2"),
               playerChargeAtlas.textureNamed("PlayerCharge3")]
    }

    func startRunningAnimation(player: Player)
    {
        let move = SKAction.animate(with: playerAnimMove, timePerFrame: 0.19)
        player.sprite.run(SKAction.repeatForever(move), withKey: "PlayerMoveAnimation")
        animRunning = true
    }
    
    func startDeathAnimation(player: Player)
    {
        let move = SKAction.animate(with: playerDeathAnimation, timePerFrame: 0.09)
        player.sprite.run(SKAction.repeatForever(move), withKey: "PlayerDeathAnimation")
    }
    
    func startJumpAnimation(player: Player)
    {
        let jump = SKAction.animate(with: playerAnimJump, timePerFrame: 0.14)
        player.sprite.run(SKAction.repeatForever(jump), withKey: "PlayerJumpAnimation")
    }
    
    func startHitAnimation(player: Player)
    {
        let hit = SKAction.animate(with: playerAnimHit, timePerFrame: 0.09)
        player.sprite.run(SKAction.repeatForever(hit), withKey: "PlayerHitAnimation")
        print("animation")
    }
    
    func startIdleAnimation(player: Player)
    {
        let idle = SKAction.animate(with: playerIdleAnimation, timePerFrame: 0.14)
        player.sprite.run(SKAction.repeatForever(idle), withKey: "PlayerIdleAnimation")
    }
    
    func startChargeAnimation(player: Player)
    {
        let move = SKAction.animate(with: playerChargeAnimation, timePerFrame: 0.14)
        player.sprite.run(SKAction.repeatForever(move), withKey: "PlayerChargeAnimation")
    }
}
