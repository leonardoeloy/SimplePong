//
//  Paddle.h
//  VolcanoPong2
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright (c) 2012 MegaBlasterSuperHeroes. All rights reserved.
//

#import "cocos2d.h"

@interface Paddle : CCNode <CCTargetedTouchDelegate> {
    CCSprite *paddleSprite;
    float paddleTouchableArea;
    CGPoint lastTouchLocation;
    BOOL isTouchHandled;
    BOOL movablePaddle;
    CGPoint nextPosition;
}

+(id) paddleWithParentNode:(CCNode *)parentNode isMovable:(BOOL)movable;
-(id) initWithParentNode:(CCNode *)parentNode isMovable:(BOOL)movable;

@property (readonly) CCSprite *paddleSprite;

@end
