//
//  Paddle.h
//  VolcanoPong2
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright (c) 2012 MegaBlasterSuperHeroes. All rights reserved.
//

#import "cocos2d.h"
#import "Paddle.h"

typedef enum ballState {
    BallStateINVALID = 1,
    BallStateMoving = 2,
    BallStateStill = 3
} BallState;

@interface Ball : CCNode <CCTargetedTouchDelegate> {
    BallState ballState;
    CCSprite *ballSprite;
    Paddle *playerPaddle, *opponentPaddle;
    int whoScored;
    
    float ballVx, ballVy, nextX, nextY, dX, dY;
}

+(id) ballWithParentNode:(CCNode *)parentNode withPlayerPaddle:(Paddle *)playerPaddle_ withOpponentPaddle:(Paddle *)opponentPaddle_;
-(id) initWithParentNode:(CCNode *)parentNode withPlayerPaddle:(Paddle *)playerPaddle_ withOpponentPaddle:(Paddle *)opponentPaddle_;

// Actions
-(void) resetBall;

@property (readwrite, assign) BallState ballState;
@property (readonly) CCSprite *ballSprite;
@property (readonly) int whoScored;

@end


