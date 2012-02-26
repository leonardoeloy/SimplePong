//
//  Paddle.m
//  VolcanoPong2
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright (c) 2012 MegaBlasterSuperHeroes. All rights reserved.
//

#import "Paddle.h"
#import "GameLayer.h"
#import "Ball.h"

@implementation Paddle

@synthesize paddleSprite;

+(id) paddleWithParentNode:(CCNode *)parentNode isMovable:(BOOL)movable {
    return [[[self alloc] initWithParentNode:parentNode isMovable:movable] autorelease];
}

-(id) initWithParentNode:(CCNode *)parentNode isMovable:(BOOL)movable {
    if ((self = [super init])) {
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        
        [parentNode addChild:self];
        
        paddleSprite = [CCSprite spriteWithFile:@"paddle.png"];
        
        if (movable) {
            [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];   
            // Define the paddle's touchable area width
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            paddleTouchableArea = (int)winSize.height / 4;
        } else {
            // Enable Paddle AI
            [self scheduleUpdate];
        }
        
        movablePaddle = movable;
        
        [self addChild:paddleSprite];
    }
    
    return self;
}

-(void) update:(ccTime)delta {
    Ball *ball = (Ball *)[[GameLayer sharedLayer] getChildByTag:BallTag];
    
    if (!movablePaddle && [ball ballState] == BallStateMoving) {
        // Just start the movement if the ball has crossed the opponent's half of the screen
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        if ([ball ballSprite].position.y >= winSize.height / 2) {
            float spriteOffset = [paddleSprite texture].contentSize.width / 2 + BACKGROUND_X_OFFSET; 
            int direction = -1;
            
            if ([ball ballSprite].position.x >= paddleSprite.position.x) {
                direction = 1;
            }
             
            nextPosition.x = clampf(paddleSprite.position.x + (150 * delta) * direction, spriteOffset, winSize.width - spriteOffset);
            nextPosition.y = paddleSprite.position.y;
            
            paddleSprite.position = nextPosition;
        }
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    lastTouchLocation = [GameLayer locationFromTouch:touch];
    // It became obvious that putting the finger exactly onto the paddle
    // isn't very usable. So we extend the area to some pixels avobe the paddle.
    // Instead of using [paddleSprite boundingBox] we make a bigger rectangle
    // with CGRectMake().
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGRect touchableArea = CGRectMake(0, 0, winSize.width, paddleTouchableArea);
    
    isTouchHandled = CGRectContainsPoint(touchableArea, lastTouchLocation);   
    
    return isTouchHandled;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event { 
    CGPoint currentTouchLocation = [GameLayer locationFromTouch:touch];
    CGPoint moveTo = ccpSub(lastTouchLocation, currentTouchLocation);
    nextPosition = CGPointMake(paddleSprite.position.x + (moveTo.x  * -1), paddleSprite.position.y);
    
    // Avoid moving off-screen
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    float spriteOffset = [paddleSprite texture].contentSize.width / 2 + BACKGROUND_X_OFFSET;         
    // Could also have used MIN(MAX()).
    nextPosition.x = clampf(nextPosition.x, spriteOffset, winSize.width - spriteOffset);
    paddleSprite.position = nextPosition;
    
    lastTouchLocation = currentTouchLocation;
}


-(void) dealloc {    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    
    [super dealloc];
}
@end
