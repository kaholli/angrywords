//
//  Helper.swift
//  AngryWords
//
//  Created by Robert Pankrath on 24.10.14.
//  Copyright (c) 2014 Lesson Nine GmbH. All rights reserved.
//

import SpriteKit

public class Helper{

    public class func CGPointSub(a: CGPoint, b: CGPoint)->CGPoint{
        return CGPointMake(a.x-b.x,a.y-b.y);
    }
    
    public class func CGPointLength(a: CGPoint)->CGFloat{
        return CGFloat(sqrtf(Float(a.x*a.x+a.y*a.y)));
    }
    
    public class func CGPointNorm(a: CGPoint)->CGPoint{
        let l = CGPointLength(a);
        if(l==0){
            return a;
        }
        return CGPointMake(a.x/l, a.y/l)
    }
    
    public class func CGPointToAngle(a: CGPoint)->CGFloat{
        return CGFloat(atan2f(Float(a.y), Float(a.x)));
    }
    
    public class func CGpointFromAngle(angle: CGFloat)->CGPoint{
        return CGPointMake(CGFloat(cosf(Float(angle))), CGFloat(sinf(Float(angle))));
    }
}