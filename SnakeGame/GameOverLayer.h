//
//  GameOverLayer.h
//  SnakeGame
//
//  Created by Jacob on 13-4-7.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOverLayer : CCLayer {
    
}

+ (CCScene *)sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end
