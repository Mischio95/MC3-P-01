//
//  SceneManagerGameScene.swift
//  MC3-Light
//
//  Created by Kiar on 08/03/23.
//

import Foundation
import SpriteKit

class GameSceneManager
{
    var scene: SKScene
    
    //MARK: QUESTITEM
    var questItem1: PickupItem?
    var questItem2: PickupItem?
    var questItem3: PickupItem?
    
   var winBox = WinBox(numberOfKey: 3)
    
    var questItemSpownPoint: SKNode
    var questItemsRef: [PickupItem] = []
    
    
//    questItemSpown1 = self.childNode(withName: "keySpown1")
//    questItemSpown2 = self.childNode(withName: "keySpown2")
//    questItemSpown3 = self.childNode(withName: "keySpown3")
//    questItemSpown1.isHidden = true
//    questItemSpown2.isHidden = true
//    questItemSpown3.isHidden = true

    
    init(scene: SKScene)
    {
        self.scene = scene
        questItemSpownPoint = self.scene.childNode(withName: "keySpown1")!
        setQuestItems()
    }
}


//MARK: QUESTITEM FUNCTION
extension GameSceneManager
{
    func setQuestItems()
    {
        questItemSpownPoint = self.scene.childNode(withName: "keySpown1")!
        questItem1 = PickupItem(GUID: winBox.GUID)
        questItem1?.sprite.position = questItemSpownPoint.position
        questItem1?.sprite.name = "questItem1"
        self.scene.addChild(questItem1!.sprite)
        questItemSpownPoint.isHidden = true
        questItemsRef.append(questItem1!)

        questItemSpownPoint = self.scene.childNode(withName: "keySpown2")!
        questItem2 = PickupItem(GUID: winBox.GUID)
        questItem2?.sprite.position = questItemSpownPoint.position
        questItem2?.sprite.name = "questItem2"
        self.scene.addChild(questItem2!.sprite)
        questItemSpownPoint.isHidden = true
        questItemsRef.append(questItem2!)

        questItemSpownPoint = self.scene.childNode(withName: "keySpown3")!
        questItem3 = PickupItem(GUID: winBox.GUID)
        questItem3?.sprite.position = questItemSpownPoint.position
        questItem3?.sprite.name = "questItem3"
        self.scene.addChild(questItem3!.sprite)
        questItemSpownPoint.isHidden = true
        questItemsRef.append(questItem3!)
    }
    
    func toggleVisibilityQuestItems(lightIsOn: Bool)
    {
        if(!lightIsOn)
        {
            for index in 0..<questItemsRef.count
            {
                questItemsRef[index].sprite.removeFromParent()
            }
        }
        else
        {
            for index in 0..<questItemsRef.count
            {
                self.scene.addChild(questItemsRef[index].sprite)
            }
        }
    }
    
    func addItemInPlayerInventory(player: Player, nameOfItemToRemove: String)
    {
        var found: Bool = false
        var index: Int = 0
        
        while !found && index < self.questItemsRef.count
        {
            if(questItemsRef[index].sprite.name == nameOfItemToRemove)
            {
                player.inventory.addItemInInventory(itemToAdd: questItemsRef[index])
                questItemsRef[index].sprite.removeFromParent()
                questItemsRef.remove(at: index)
                found = true
            }
            index += 1
        }
    }
}
