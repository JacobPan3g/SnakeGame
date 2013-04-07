//
//  Snake.h
//  SnakeGame
//
//  Created by Jacob on 13-4-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class HelloWorldLayer;

@interface Snake : CCNode {
    HelloWorldLayer *_game;
    CCSprite *_head;
    NSMutableArray *_body;
    CGPoint _dir;
}

- (id) initWithTheGame:(HelloWorldLayer *)game;
- (CGPoint) getHeadPosition;
- (CGPoint) getDir;
- (int) getHeadImageSize;
- (NSArray *)getBodyPosition;
- (NSArray*) getAllPosition;
- (void) move;
- (void) moveWithDir:(CGPoint)dir;
- (void) eatedFood;
- (void) willDie;

@end
