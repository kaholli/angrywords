//
//  LetterNode.swift
//  AngryWords
//
//  Created by Robert Pankrath on 24.10.14.
//  Copyright (c) 2014 Lesson Nine GmbH. All rights reserved.
//

import SpriteKit

class LetterNode: SKLabelNode {

    var bird : SKSpriteNode = SKSpriteNode()
    
    var index: NSInteger = -1
    
    func setLetter(letter: String, index: NSInteger, bird: SKSpriteNode ){
//        self.size = CGSizeMake(40, 40)
        self.name = "letter"
        self.fontSize = 40
        self.fontName = "HelveticaNeue-Bold"
        self.color = SKColor.whiteColor()
        self.colorBlendFactor = 1
        self.xScale = 0.4
        self.yScale = 0.4
        self.text = letter
        self.index = index
        self.bird = bird
        self.position = CGPointMake(bird.position.x, bird.position.y-15)
    }
    
    func updatePosition(){
        self.position = CGPointMake(bird.position.x, bird.position.y-15)
    }
}