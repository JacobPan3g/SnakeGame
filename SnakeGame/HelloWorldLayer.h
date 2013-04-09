//
//  HelloWorldLayer.h
//  SnakeGame
//
//  Created by Jacob on 13-4-2.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

@class Snake;
@class AiSanke;

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    Snake *_snake;
    AiSanke *_aiSnake;
    CCSprite *_food;
    
    CCLabelTTF *_snakeSorceLabel;
    CCLabelTTF *_aiSnakeSorceLabel;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
