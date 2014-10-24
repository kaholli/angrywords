//
//  GameScene.swift
//  AngryWords
//
//  Created by Robert Pankrath on 24.10.14.
//  Copyright (c) 2014 Lesson Nine GmbH. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var terrain : TerrainNode = TerrainNode()

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        terrain.createTerrain(-40, length: self.size.width+80, miny: 50, maxY: 500, initialFlatLength: 200, endFlatRange: 500)
        terrain.position = CGPoint(x: 0, y: 0)
        self.addChild(terrain)
        createTarget()
    }
    
    func createTarget(){
        
        var xRange = terrain.targetAreaXRange
        let baseY = terrain.targetAreaY
        
        var blockLength = CGFloat(80)
        NSLog("xRange:%i %i", xRange.location, xRange.length)
        for var i=CGFloat(xRange.location + 10); i<CGFloat(xRange.location + xRange.length); i+=blockLength {
            createBlock(CGPoint(x: i, y: baseY+blockLength/2), length: blockLength, vertical: true)
        }
        
        for var i=CGFloat(xRange.location + 10); i<CGFloat(xRange.location + xRange.length); i+=blockLength {
            createBlock(CGPoint(x: i, y: baseY+blockLength), length: blockLength, vertical: false)
        }
        
    }
    
    func createBlock(pos: CGPoint, length:CGFloat, vertical:Bool){
        var w = vertical ? 10 : length;
        var h = vertical ? length : 10;
        var node = SKSpriteNode(color: SKColor(red: 0.3, green:0, blue: 0.4, alpha: 1), size: CGSize(width: w, height: h));
        node.name = "block"
        node.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: w, height: h))
        node.position = pos
        self.addChild(node)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}
