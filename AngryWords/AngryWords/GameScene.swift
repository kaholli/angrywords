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
       
        self.backgroundColor = AngyWordsStyleKit.babbelBlue
        
        terrain.createTerrain(-40, length: self.size.width+80, miny: 50, maxY: 500, initialFlatLength: 200, endFlatRange: 500)
        terrain.position = CGPoint(x: 0, y: 0)
        terrain.zPosition = 1
        createClouds()
        self.addChild(terrain)
        createTarget()
        createSling()
    }
    
    func createClouds(){
        
        for var x=50; x<Int(self.size.width); x+=200{
            var y = (random()%Int(self.size.height/2)) + Int(self.size.height/2)
            var texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasCloud)
            var cloud = SKSpriteNode(texture: texture)
            cloud.xScale = 0.6
            cloud.yScale = 0.6
            cloud.position = CGPoint(x: x, y: y)
            cloud.zPosition = 0
            var dx = CGFloat(random()%40)
            var dur = NSTimeInterval(random()%5)+5
            var move1 = SKAction.moveByX(dx, y: 0, duration: dur)
            var move2 = SKAction.moveByX(-dx, y: 0, duration: dur)
            var action = SKAction.repeatActionForever(SKAction.sequence([ move1, move2]))
            cloud.runAction(action)
            self.addChild(cloud)
        }
        
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
        node.zPosition = 10
        self.addChild(node)
    }
    
    func createSling(){
        var xpos = terrain.startAreaXRange.location + terrain.startAreaXRange.length/2
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
      
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
}
