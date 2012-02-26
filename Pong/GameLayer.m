//
//  GameLayer.m
//  VolcanoPongProto2
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright MegaBlasterSuperHeroes 2012. All rights reserved.
//

#import "GameLayer.h"
#import "Paddle.h"
#import "Ball.h"

static GameLayer *gameLayerInstance;

@interface GameLayer (PrivateMethods)
-(void) resetGame;
@end

@implementation GameLayer

+(GameLayer *) sharedLayer {
    NSAssert(gameLayerInstance != nil, @"GameLayer not available!");
    return gameLayerInstance;
}

-(GameLayer *)gameLayer {
    CCNode *layer = [self getChildByTag:GameLayerTag];
    
    NSAssert([layer isKindOfClass:[GameLayer class]], @"%@: not a GameLayer!", NSStringFromSelector(_cmd));
    
    return (GameLayer *)layer;
    
}

+(CGPoint) locationFromTouch:(UITouch*)touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	return [[CCDirector sharedDirector] convertToGL:touchLocation];
}


+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	
	[scene addChild: layer z:0 tag:GameLayerTag];
	
	return scene;
}

-(id) init
{
	if( (self = [super init])) {
		NSAssert(gameLayerInstance == nil, @"Another GameLayer is already in use!");
		gameLayerInstance = self;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];  
        CCSprite *background = [CCSprite spriteWithFile:@"background.png"];
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:-1];
      
        Paddle *playerPaddle = [Paddle paddleWithParentNode:self isMovable:YES];
        Paddle *opponentPaddle = [Paddle paddleWithParentNode:self isMovable:NO];
        Ball *ball = [Ball ballWithParentNode:self withPlayerPaddle:playerPaddle withOpponentPaddle:opponentPaddle];
        
        playerPaddle.tag = PlayerTag;        
        opponentPaddle.tag = OpponentTag;
        ball.tag = BallTag;
        
        playerScoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:80];
        playerScoreLabel.position = ccp(winSize.width/2, winSize.height/4);
        [self addChild:playerScoreLabel z:-1];
        
        opponentScoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:80];
        opponentScoreLabel.position = ccp(winSize.width/2, winSize.height - winSize.height/4);
        [self addChild:opponentScoreLabel z:-1];
        
        [self resetGame];
        
        [self scheduleUpdate];
	}
    
	return self;
}

-(void) resetGame {
    CCLOG(@"Resetting game!");
    playerScore = 0;
    opponentScore = 0;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *paddleSprite = [CCSprite spriteWithFile:@"paddle.png"]; 
    
    CGPoint playerPaddlePosition = CGPointMake(winSize.width / 2 , [paddleSprite texture].contentSize.height + BACKGROUND_Y_OFFSET);
    CGPoint opponentPaddlePosition = CGPointMake(winSize.width / 2 , winSize.height - [paddleSprite texture].contentSize.height - BACKGROUND_Y_OFFSET);
    CGPoint ballPosition = CGPointMake(winSize.width/2, winSize.height/2);
    
    Ball *ball = (Ball *)[self getChildByTag:BallTag];
    Paddle *playerPaddle = (Paddle *)[self getChildByTag:PlayerTag];
    Paddle *opponentPaddle = (Paddle *)[self getChildByTag:OpponentTag];
    
    [ball ballSprite].position = ballPosition;
    [playerPaddle paddleSprite].position = playerPaddlePosition;
    [opponentPaddle paddleSprite].position = opponentPaddlePosition;
}

-(void) update:(ccTime)delta {
    Ball *ball = (Ball *)[self getChildByTag:BallTag];
    int whoScore = [ball whoScored];
    if (whoScore > 0) {
        Paddle *playerPaddle = (Paddle *)[self getChildByTag:PlayerTag]; 
        Paddle *opponentPaddle = (Paddle *)[self getChildByTag:OpponentTag];
        CGPoint position;
        
        if (whoScore == PlayerTag) {
            position = CGPointMake([opponentPaddle paddleSprite].position.x, 1 + [opponentPaddle paddleSprite].position.y - [[opponentPaddle paddleSprite] texture].contentSize.height + [[ball ballSprite] texture].contentSize.height/4);
            [playerScoreLabel setString:[NSString stringWithFormat:@"%i", ++playerScore]];
        } else if (whoScore == OpponentTag) {
            position = CGPointMake([playerPaddle paddleSprite].position.x, [playerPaddle paddleSprite].position.y + [[playerPaddle paddleSprite] texture].contentSize.height - [[ball ballSprite] texture].contentSize.height/4);
            [opponentScoreLabel setString:[NSString stringWithFormat:@"%i", ++opponentScore]];
        }
        
        [ball ballSprite].position = position;
        [ball resetBall];
        [ball setBallState:BallStateStill];
    }
}

-(void) openingScene {
    
}

- (void) dealloc
{
    gameLayerInstance = nil;
	[super dealloc];
}
@end
