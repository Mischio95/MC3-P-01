//
//  Utilities.swift
//  MC3-Light
//
//  Created by Michele Trombone  on 25/02/23.
//

import Foundation
import SwiftUI
import SpriteKit

var joystickButtonClicked = false
var animRunning = false
var gameOverControlFlag = false
var playerLightIsOnGlobal = false
var playerSpeed = CGPoint.zero

var chooseSound = true
var chooseVibration = true
 
var timerStopped = false

struct Utilities
{
    struct CollisionBitMask
    {
        static let playerCategory:UInt32 = 1
        static let enemyCategory:UInt32 = 2
        static let groundCategory:UInt32 = 3
        static let chargingBoxCategory:UInt32 = 4
        static let itemCatecory:UInt32 = 5
        static let winBoxCategory:UInt32 = 6
        static let enemyViewCategory:UInt32 = 7
        static let invisibleGroundCategory: UInt32 = 8
        static let floppyDiskCategory: UInt32 = 9
        static let soundTriggerCategory: UInt32 = 10
    }
}
