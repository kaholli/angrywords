//
//  LetterNode.swift
//  AngryWords
//
//  Created by Robert Pankrath on 24.10.14.
//  Copyright (c) 2014 Lesson Nine GmbH. All rights reserved.
//

import SpriteKit

class LetterNode: SKSpriteNode {

    var bird : SKSpriteNode = SKSpriteNode()
    
    var index: NSInteger = -1
    
    func setLetter(letter: String, index: NSInteger, bird: SKSpriteNode ){
        self.size = CGSizeMake(40, 40)
        self.colorBlendFactor = 1;
        self.color = SKColor.blackColor()
        self.name = "letter"
        self.xScale = 0.4
        self.yScale = 0.4
        self.index = index
        self.bird = bird
        self.updatePosition()
        setTextureFromLetter(letter)
    }
    
    func updatePosition(){
        self.position = CGPointMake(bird.position.x, bird.position.y-7)
    }
    
    func setTextureFromLetter(letter: String){
        switch (letter.uppercaseString){
        case "B": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterB)
        case "A": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterA)
        case "E": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterE)
        case "L": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterL)
        case "-": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetter)
        case "H": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterH)
        case "C": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterC)
        case "K": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterK)
        case "D": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterD)
        case "Y": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetterY)
        case "2": self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetter2)
        default: self.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasLetter)
        }
    }
}