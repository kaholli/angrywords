//
//  GameScene.swift
//  AngryWords
//
//  Created by Robert Pankrath on 24.10.14.
//  Copyright (c) 2014 Lesson Nine GmbH. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var terrain : TerrainNode = TerrainNode()

    var slingback : SKSpriteNode  = SKSpriteNode()
    var slingfront : SKSpriteNode  = SKSpriteNode()
    var slingDrawer : SKSpriteNode = SKSpriteNode()
    var initialDrawerPos:CGPoint = CGPointZero
    
    var slingBase : SKSpriteNode = SKSpriteNode();
    
    var slingpos1 : CGPoint = CGPointZero
    var slingpos2 : CGPoint = CGPointZero
    
    
    var camera : SKNode = SKNode()
    
    var touchStartPoint :CGPoint = CGPointZero
    
    var mapNode = SKNode()
    
    var isDraggingSwing :(Bool)  = false
    
    var babbelworm : SKSpriteNode = SKSpriteNode(color: SKColor.orangeColor(), size: CGSizeMake(50, 50))
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        self.backgroundColor = AngyWordsStyleKit.babbelBlue
        self.physicsWorld.contactDelegate = self;
        
        self.addChild(mapNode)
        terrain.createTerrain(-40, length: 2000, miny: 50, maxY: 500, initialFlatLength: 700, endFlatRange: 500)
        terrain.position = CGPoint(x: 0, y: 0)
        terrain.zPosition = 1
        createClouds()
        mapNode.addChild(terrain)
        createTarget()
        createSling()
        
        babbelworm = SKSpriteNode(texture: SKTexture(image: AngyWordsStyleKit.imageOfCanvasBabbelFigure))
        mapNode.addChild(babbelworm);
        babbelworm.zPosition = 15
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

        
        var numBlocks = (xRange.length-40)/Int(blockLength)
        
        let width = CGFloat(xRange.length-40)
        var y = baseY;
        
        while numBlocks>0{
        
            let xoff = (width-CGFloat(numBlocks)*blockLength)/2
            
            
            for var i=0; i<numBlocks+1;i++ {
                let x = CGFloat(xRange.location)+xoff+CGFloat(i)*blockLength;
                createBlock(CGPoint(x: x, y: y+blockLength/2), length: blockLength, vertical: true)
            }
            
            for var i=0; i<numBlocks;i++ {
                let x = CGFloat(xRange.location)+xoff+CGFloat(i)*blockLength + blockLength/2;
                createBlock(CGPoint(x: x, y: y+blockLength + 8), length: blockLength, vertical: false)
            }
            
            numBlocks--;
            y += blockLength+16
        }
        
        
    }
    
    func createBlock(pos: CGPoint, length:CGFloat, vertical:Bool){
        var w = vertical ? 16 : length;
        var h = vertical ? length : 16;
        var node = SKSpriteNode(color: SKColor(red: 0.3, green:0, blue: 0.4, alpha: 1), size: CGSize(width: w, height: h));
        if vertical {
            node.color = SKColor.greenColor()
        }
        var image = vertical ? AngyWordsStyleKit.imageOfCanvasWoodBlockVertical : AngyWordsStyleKit.imageOfCanvasWoodBlockHorizontal
        node.texture = SKTexture(image: image )
        
        let red = CGFloat(random()%1000)/3000;
        let green = CGFloat(0);
        let blue = CGFloat(random()%1000)/2000;
        node.color = SKColor(red: red, green: green, blue: blue, alpha: 1)
        node.colorBlendFactor = 0.5
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
        
        slingBase.zPosition = 20
        back.zPosition = 10
        front.zPosition = 20
        
        mapNode.addChild(back)
        mapNode.addChild(front)
        mapNode.addChild(slingBase)
        mapNode.addChild(slingDrawer)
        
//        slingDrawer.size = CGSizeMake(10, 10)
//        slingDrawer.color = SKColor.redColor()
//        slingDrawer.colorBlendFactor = 1
        slingDrawer.zPosition = 100;
        slingDrawer.position = CGPoint(x: slingBase.position.x, y: slingBase.position.y+slingBase.size.height/2)
        initialDrawerPos = slingDrawer.position
        
        slingpos1 = CGPointMake(slingBase.position.x-slingBase.size.width/2, slingBase.position.y+slingBase.size.height/2)
        slingpos2 = CGPointMake(slingBase.position.x+slingBase.size.width/2, slingBase.position.y+slingBase.size.height/2)
        
//        var dummy = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(10, 10))
//        dummy.zPosition = 100
//        dummy.position = slingpos1
//        mapNode.addChild(dummy)
//        
//        dummy = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(10, 10))
//        dummy.zPosition = 100
//        dummy.position = slingpos2
//        mapNode.addChild(dummy)
        
        
        slingfront.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSling)
        slingfront.zPosition = 19;
        mapNode.addChild(slingfront);
        
        slingback.texture = SKTexture(image: AngyWordsStyleKit.imageOfCanvasSling)
        slingback.zPosition = 9
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
            babbelworm.physicsBody = nil
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
            setCameraPosition(CGPointMake(x, camera.position.y))
        }
        touchStartPoint = location
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if isDraggingSwing {
            var p2 = slingDrawer.position
            var p1 = slingpos2
            var p21  = Helper.CGPointSub(p1, b: p2)
            var l = Helper.CGPointLength(p21);

            babbelworm.physicsBody = SKPhysicsBody(rectangleOfSize: babbelworm.size)
            babbelworm.physicsBody?.applyImpulse(CGVectorMake(p21.x/2, p21.y/2))
            
            slingDrawer.runAction(SKAction.moveTo(initialDrawerPos, duration: 0.4))
        }
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        if let body = babbelworm.physicsBody{
            var resting = body.resting
            if resting {
                babbelworm.physicsBody = nil;
                camera.runAction(SKAction.moveTo(CGPointZero, duration: 2));
            }else{
                if(babbelworm.position.x>terrain.length){
                    babbelworm.physicsBody = nil;
                    camera.runAction(SKAction.moveTo(CGPointZero, duration: 2));
                }
                
            }
            
            
        }
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

        if isDraggingSwing {
            babbelworm.position = slingDrawer.position
        }
    }
    
    override func didSimulatePhysics() {
        if babbelworm.physicsBody != nil {
            setCameraPosition(CGPointMake(-babbelworm.position.x, camera.position.y))
        }else{
            updateSling()
        }
        
        mapNode.position = CGPointMake(camera.position.x, 0)
    }
    
    func setCameraPosition(pos : CGPoint){
        var x = pos.x
        if x>0 {
            x=0;
        }else if x < -(terrain.length-self.size.width){
            x = -(terrain.length-self.size.width)
        }
        
        camera.position = CGPointMake(x, camera.position.y);
    }
 
    func didBeginContact(contact: SKPhysicsContact) {
        
    }
    
}
