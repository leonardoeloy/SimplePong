//
//  Paddle.m
//  VolcanoPong2
//  The ball collision logic was heavily based on https://github.com/Ricket/richardcarter.org/blob/master/content/scripts/pong.js Copyrighted to Richard Carter.
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright (c) 2012 MegaBlasterSuperHeroes. All rights reserved.
//

#import "Ball.h"
#import "GameLayer.h"

@interface Ball (PrivateMethods) 
-(BOOL) isBetween:(float)number fromInclusive:(int)from to:(int)to;
-(void) scoreTo:(int)whoScored_;
//-(void) animateBallFalling;
@end

@implementation Ball 

@synthesize ballState;
@synthesize ballSprite;
@synthesize whoScored;

+(id) ballWithParentNode:(CCNode *)parentNode withPlayerPaddle:(Paddle *)playerPaddle_ withOpponentPaddle:(Paddle *)opponentPaddle_ {
    return [[[self alloc] initWithParentNode:parentNode withPlayerPaddle:playerPaddle_ withOpponentPaddle:opponentPaddle_] autorelease];
}

-(id) initWithParentNode:(CCNode *)parentNode withPlayerPaddle:(Paddle *)playerPaddle_ withOpponentPaddle:(Paddle *)opponentPaddle_ {
    if ((self = [super init])) {
        [parentNode addChild:self];
        
        playerPaddle = playerPaddle_;
        opponentPaddle = opponentPaddle_;
        
        ballSprite = [CCSprite spriteWithFile:@"ball.png"];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES]; 
        
        [self addChild:ballSprite];
        [self resetBall];
        
        // Randomize ball direction
        dX = [self randomInteger];
        dY = [self randomInteger];
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(BOOL) isBetween:(float)number fromInclusive:(int)from to:(int)to {
    return (number >= from && number < to);
}

-(void) update:(ccTime)delta {
    if (ballState == BallStateMoving) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize ballTexture = [ballSprite texture].contentSize;
        
        if (CGRectIntersectsRect([ballSprite boundingBox], [[playerPaddle paddleSprite] boundingBox])) {
            CCLOG(@"Collided to player");
            float collisionPos = [playerPaddle paddleSprite].position.x - ballSprite.position.x;
            float normalizedIntersectX = collisionPos / ([[playerPaddle paddleSprite] texture].contentSize.width/2); 
            float bounceAngle = normalizedIntersectX * CC_DEGREES_TO_RADIANS(75);
            ballVy = 200 * cosf(bounceAngle);
            ballVx = 200 * -sinf(bounceAngle);
            
            CCLOG(@"!!!! pos=%f nIx=%f ba=%f vx=%f vy=%f", collisionPos, normalizedIntersectX, bounceAngle, ballVx, ballVy);            
        } else if (CGRectIntersectsRect([ballSprite boundingBox], [[opponentPaddle paddleSprite] boundingBox])) {
            CCLOG(@"Collided to opponent");
            float collisionPos = [opponentPaddle paddleSprite].position.x - ballSprite.position.x;
            float normalizedIntersectX = collisionPos / ([[opponentPaddle paddleSprite] texture].contentSize.width/2); 
            float bounceAngle = normalizedIntersectX * CC_DEGREES_TO_RADIANS(75);
            ballVy = 200 * -cosf(bounceAngle);
            ballVx = 200 * -sinf(bounceAngle);
            
            CCLOG(@"!!!! pos=%f nIx=%f ba=%f vx=%f vy=%f", collisionPos, normalizedIntersectX, bounceAngle, ballVx, ballVy);
        }
        
        if ((ballSprite.position.x >= winSize.width - [ballSprite texture].contentSize.width/2 - BACKGROUND_X_OFFSET) || (ballSprite.position.x <= [ballSprite texture].contentSize.width/2 + BACKGROUND_X_OFFSET)) {
            ballVx *= -1;
        } 
        
        if (ballSprite.position.y >= winSize.height - [ballSprite texture].contentSize.width/2 - OPPONENT_PADDLE_OFFSET) {
            [self scoreTo:PlayerTag];
            return;
        } else if (ballSprite.position.y <= [ballSprite texture].contentSize.height/2 + PLAYER_PADDLE_OFFSET) {
            [self scoreTo:OpponentTag];
            return;
        }
        
        nextX = ballSprite.position.x + ballVx * delta;// * dX;
        nextY = ballSprite.position.y + ballVy * delta;// * dY;
        
        ballSprite.position = ccp(nextX, nextY);
    }
}

-(void) scoreTo:(int)whoScored_ {
    CCLOG(@"Player %d has scored!", whoScored_);
    whoScored = whoScored_;
    
    if (whoScored == OpponentTag) {
        dY = -1;
    } else if (whoScored == PlayerTag) {
        dY = 1;
    }
    
    ballState = BallStateStill;
    
//    [self animateBallFalling];
}

-(void) resetBall {
    CCLOG(@"Ball reseted!");
    ballState = BallStateStill;
    whoScored = 0;
    ballVx = 200 * cos(CC_DEGREES_TO_RADIANS(60)) * [self randomInteger];
    ballVy = 200 * sin(CC_DEGREES_TO_RADIANS(60)) * [self randomInteger];
}

-(int) randomInteger {
    srandom(time(NULL));
    
    if (CCRANDOM_MINUS1_1() >= 0) {
        return 1;
    }
    
    return -1;
}

/* Gotta work on this 
-(void) animateBallFalling {
//    float moveNextX = ballSprite.position.x + ballVx * 0.5 * dX;
//    float moveNextY = ballSprite.position.x + ballVy * 0.5 * dY;
    
    // Make the ball fall & scale it down
    CCMoveBy *moveAwayFromBoard = [CCMoveBy actionWithDuration:0.1f position:ccp(5 * dX, 5 * dY)];
    CCScaleTo *scaleDown = [CCScaleTo actionWithDuration:0.1f scale:0.6f];
    
    // Make the ball move a little and scale it up, simulating a bounce
    CCScaleTo *scaleUp = [CCScaleTo actionWithDuration:0.2f scale:0.8f];
    
    CCSequence *fall = [CCSequence actions:moveAwayFromBoard, scaleDown, nil];
    CCSequence *bounce = [CCSequence actions:scaleUp, moveAwayFromBoard, scaleDown, nil];

    CCSequence *action = [CCSequence actionOne:fall two:bounce];
    [ballSprite runAction:moveAwayFromBoard];
    [ballSprite runAction:scaleUp];
    //[ballSprite runAction:action];
}
 */

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return (ballState == BallStateStill);
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event { 
    NSAssert(ballState != BallStateINVALID, @"Ball state set to INVALID!");
    
    dX = -1;
    dY = -1;
    
    ballVx = 200 * cos(CC_DEGREES_TO_RADIANS(60));
    ballVy = 200 * sin(CC_DEGREES_TO_RADIANS(60));
    
    ballState = BallStateMoving;
}

-(void) dealloc {
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super dealloc];
}

@end
