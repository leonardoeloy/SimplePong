//
//  GameLayer.h
//  VolcanoPongProto2
//
//  Created by Leonardo Eloy on 08/02/12.
//  Copyright MegaBlasterSuperHeroes 2012. All rights reserved.
//

#import "cocos2d.h"

#define PlayerTag 1
#define OpponentTag 2
#define GameLayerTag 3
#define BallTag 4

#define PLAYER_PADDLE_OFFSET 35
#define OPPONENT_PADDLE_OFFSET 25
#define BACKGROUND_X_OFFSET 18

@interface GameLayer : CCLayer
{
    int playerScore, opponentScore;
    CCLabelTTF *playerScoreLabel, *opponentScoreLabel;
}

+(CCScene *) scene;
+(GameLayer *) sharedLayer;
+(CGPoint) locationFromTouch:(UITouch*)touch;

@end
