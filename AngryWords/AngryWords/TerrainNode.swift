//
//  TerrainNode.swift
//  AngryWords
//
//  Created by Robert Pankrath on 24.10.14.
//  Copyright (c) 2014 Lesson Nine GmbH. All rights reserved.
//

import SpriteKit

class TerrainNode: SKShapeNode {

    var targetAreaY = CGFloat(0)
    var startAreaY = CGFloat(0)
    var targetAreaXRange = NSMakeRange(0, 0)
    var startAreaXRange = NSMakeRange(0, 0)
    var length :CGFloat = 0;

    func createTerrain(fromX: CGFloat, length: CGFloat , miny:CGFloat, maxY:CGFloat, initialFlatLength: CGFloat , endFlatRange: CGFloat){
        self.length = length
        var path = UIBezierPath()
        
        var x = fromX;
        var y = randomBetween(miny+60, max: maxY)
        
        startAreaY = y;
        path.moveToPoint(CGPoint(x: x, y: y))
        
        startAreaXRange = NSMakeRange(Int(x), Int(initialFlatLength))

        x += initialFlatLength;
        path.addLineToPoint(CGPoint(x: x , y: y))
        
        x  = length  - endFlatRange;
        
        y = miny + 60
        targetAreaY = y
        path.addQuadCurveToPoint(CGPoint(x: x, y: targetAreaY), controlPoint: CGPoint(x:x/2,y:randomBetween(miny, max: maxY)))
        
        targetAreaXRange = NSMakeRange(Int(x), Int(endFlatRange))
        
        x += endFlatRange
        
        path.addLineToPoint(CGPoint(x: x, y:y))
        
        
        path.addLineToPoint(CGPoint(x: x, y: -100))
        path.addLineToPoint(CGPoint(x: fromX, y: -100))
        path.closePath()
        
        self.path = path.CGPath
        
        
        self.fillColor = SKColor(red: 0.9, green: 0.87, blue: 0.6, alpha: 1)
        self.strokeColor = SKColor(red: 0.5, green: 0.45, blue: 0.1, alpha: 1)
//        self.lineWidth = 20
        self.physicsBody = SKPhysicsBody(edgeChainFromPath: path.CGPath)
        
        makeTexture()
    }
    
    func randomBetween(min: CGFloat, max:CGFloat)->CGFloat{
        let mi = Int(min);
        let ma = Int(max);
        let result = random()%(ma-mi);
        return CGFloat(mi + result);
    }
    
    func makeTexture(){
        let targetDimension = max(self.frame.size.width, self.frame.size.height)
        let targetSize = CGSizeMake(targetDimension, targetDimension)
        let image = AngyWordsStyleKit.imageOfCanvasSandLines
        let targetRef = image.CGImage
        let tileSize = image.size
        
        UIGraphicsBeginImageContext(targetSize)
        let contextRef = UIGraphicsGetCurrentContext()
        CGContextDrawTiledImage(contextRef, CGRectMake(0,0,tileSize.width,tileSize.height), targetRef)
        let tiledTexture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.fillTexture = SKTexture(image: tiledTexture)
    }
    
}