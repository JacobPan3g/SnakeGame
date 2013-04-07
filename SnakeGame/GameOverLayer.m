//
//  GameOverLayer.m
//  SnakeGame
//
//  Created by Jacob on 13-4-7.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"


@implementation GameOverLayer

+ (CCScene *)sceneWithWon:(BOOL)won
{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild:layer];
    return scene;
}

- (id)initWithWon:(BOOL)won
{
    if ( self = [super init] )
    {
        NSString *message;
        if (won)
        {
            message = [NSString stringWithFormat:@"You Won!"];
        }
        else
        {
            message = @"You Lose :[";
        }

        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:16];
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
        }],
          nil]
         ];
    }
    return self;
}

@end
