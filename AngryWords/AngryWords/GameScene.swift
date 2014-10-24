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

    var slingback : SKSpriteNode  = SKSpriteNode()
    var slingfront : SKSpriteNode  = SKSpriteNode()
    var slingDrawer : SKNode = SKNode()
    var slingBase : SKSpriteNode = SKSpriteNode();
    
    var slingpos1 : CGPoint = CGPointZero
    var slingpos2 : CGPoint = CGPointZero
    
    
    var camera : SKNode = SKNode()
    
    var touchStartPoint :CGPoint = CGPointZero
    
    var mapNode = SKNode()
    
    var isDraggingSwing :(Bool)  = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        self.backgroundColor = AngyWordsStyleKit.babbelBlue
        
        self.addChild(mapNode)
        terrain.createTerrain(-40, length: 2000, miny: 50, maxY: 500, initialFlatLength: 700, endFlatRange: 500)
        terrain.position = CGPoint(x: 0, y: 0)
        terrain.zPosition = 1
        createClouds()
        mapNode.addChild(terrain)
        createTarget()
        createSling()
        
        self.addChild(camera)
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
            mapNode.addChild(cloud)
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
        mapNode.addChild(node)
    }
    
    func createSling(){
        var xpos = CGFloat(terrain.startAreaXRange.location + terrain.startAreaXRange.length/2)
        var ypos = terrain.startAreaY
        
        var texBack = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSchleuderHinten)
        var texFront = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSchleuderVorne)
        var texBase = SKTexture(image: AngyWordsStyleKit.imageOfCanvasStamm)

        var back = SKSpriteNode(texture: texBack)
        var front = SKSpriteNode(texture: texFront)
        slingBase = SKSpriteNode(texture: texBase)
        
        slingBase.position = CGPoint(x: xpos, y: ypos+slingBase.size.height/2)
        back.position = slingBase.position
        front.position = slingBase.position
        slingBase.name = "sling"
        
        slingBase.zPosition = 6
        back.zPosition = 4
        front.zPosition = 6
        
        mapNode.addChild(back)
        mapNode.addChild(front)
        mapNode.addChild(slingBase)
        
        slingDrawer.position = CGPoint(x: slingBase.position.x, y: slingBase.position.y+slingBase.size.height)
        
        slingpos1 = CGPointMake(slingBase.position.x-slingBase.size.width/2, slingBase.position.y+slingBase.size.height)
        slingpos2 = CGPointMake(slingBase.position.x+slingBase.size.width/2, slingBase.position.y+slingBase.size.height)
        
        slingfront.color = SKColor.redColor();
        slingfront.colorBlendFactor = 1;
        slingfront.zPosition = 5;
        mapNode.addChild(slingfront);
        
        slingback.color = SKColor.redColor();
        slingback.colorBlendFactor = 1;
        slingback.zPosition = 3
        mapNode.addChild(slingback);

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        let touch: AnyObject = touches.anyObject()!

        isDraggingSwing = false
        let location = touch.locationInNode(self)
        
        let locationInMap = touch.locationInNode(mapNode)
        if(slingBase.containsPoint(locationInMap)){
            isDraggingSwing = true
            slingDrawer.position = location
            updateSling()
        }
        
        touchStartPoint = location
    }
   
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch: AnyObject = touches.anyObject()!
        let location = touch.locationInNode(self)
        
        if(isDraggingSwing){
            slingDrawer.position = location
            updateSling()
        }
        else{
            let translation = location.x-touchStartPoint.x;
            
            var x = camera.position.x + translation;
            
            if x>0 {
                x=0;
            }else if x < -(terrain.length-self.size.width){
                x = -(terrain.length-self.size.width)
            }
            
            camera.position = CGPointMake(x, camera.position.y);
        }
        touchStartPoint = location
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func updateSling() {
//        slingback.position = slingDrawer.
        
        let h = CGFloat(5)
        
        var p1 = slingpos1
        var p2 = slingDrawer.position
        var p21  = Helper.CGPointSub(p1, b: p2)
        var l = Helper.CGPointLength(p21);
        p21 = Helper.CGPointNorm(p21)
        var midPoint = CGPointMake(p2.x + p21.x*l/2 , p2.y+p21.y*l/2)
        
        slingback.position = midPoint;
        slingback.size = CGSize(width: l, height: h);
        slingback.zRotation = Helper.CGPointToAngle(p21);

        
        p1 = slingpos2
        p2 = slingDrawer.position
        p21  = Helper.CGPointSub(p1, b: p2)
        l = Helper.CGPointLength(p21);
        p21 = Helper.CGPointNorm(p21)
        midPoint = CGPointMake(p2.x + p21.x*l/2 , p2.y+p21.y*l/2)
        
        slingfront.position = midPoint;
        slingfront.size = CGSize(width: l, height: h);
        slingfront.zRotation = Helper.CGPointToAngle(p21);

    }
    
    override func didSimulatePhysics() {
        mapNode.position = CGPointMake(camera.position.x, 0)
    }
}
