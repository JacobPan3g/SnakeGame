//
//  AiSanke.h
//  SnakeGame
//
//  Created by Jacob on 13-4-7.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Snake.h"

@interface AiSanke : Snake {
    NSMutableArray *_road;
    int idxForRoad;
}

- (void)moveNextWithAntherSnake:(NSArray*)snake withFood:(CGPoint)food;

//- (NSArray *)getRoad:(CGPoint)fondPosition;
//- (void)move;

@end
