//
//  PlayerController.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 25/02/23.
//

import Foundation
import SpriteKit
import GameController


class PlayerController
{
    var virtualController: GCVirtualController?

    var touchLeft: SKSpriteNode!
    var touchRight: SKSpriteNode!
    var touchJump: SKSpriteNode!
    var touchLightOnOff: SKSpriteNode!
    
    init(virtualController: GCVirtualController? = nil, touchLeft: SKSpriteNode!, touchRight: SKSpriteNode!, touchJump: SKSpriteNode!, touchLightOnOff: SKSpriteNode!) {
        self.virtualController = virtualController
        self.touchLeft = touchLeft
        self.touchRight = touchRight
        self.touchJump = touchJump
        self.touchLightOnOff = touchLightOnOff
        CreateInputButton()
    }
    
    func CreateInputButton()
    {
        touchLeft?.size = CGSize(width: 110, height: 110)
        touchLeft?.name = "left"
        touchLeft?.zRotation = 1.5708
        touchLeft?.zPosition = Utilities.ZIndex.HUD

        touchRight?.size = CGSize(width: 110, height: 110)
        touchRight?.name = "right"
        touchRight?.zRotation = -1.5708
        touchRight?.zPosition = Utilities.ZIndex.HUD
        
        touchJump?.size = CGSize(width: 90, height: 90)
        touchJump?.name = "jump"
        touchJump?.zPosition = Utilities.ZIndex.HUD
        
        touchLightOnOff?.size = CGSize(width: 90, height: 90)
        touchLightOnOff?.name = "lightOnOff"
        touchLightOnOff?.zPosition = Utilities.ZIndex.HUD
    }
    
    
    func connectVirtualController()
    {
        let controllerConfig = GCVirtualController.Configuration()
        controllerConfig.elements = [GCInputLeftThumbstick]
        
        let controller = GCVirtualController(configuration: controllerConfig)
        virtualController = controller
    }
}
