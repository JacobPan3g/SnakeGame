//
//  AiSanke.m
//  SnakeGame
//
//  Created by Jacob on 13-4-7.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "AiSanke.h"


@implementation AiSanke

- (NSArray *)getRoad:(CGPoint)fondPosition
{
    if ( _road != nil )
    {
        [_road release];
    }
    _road = [[NSMutableArray alloc] init];
    
    int imageWidth = _head.contentSize.width;
    CGPoint tmp = ccpSub(fondPosition, _head.position);
    CGPoint nextDir;
    
    int step = tmp.x / imageWidth;
    if ( step >= 0 )
    {
        for ( int i = 1; i <= step; i++ ) {
            nextDir = ccp( 1,0 );
            [_road addObject:[NSValue valueWithCGPoint:nextDir]];
        }
    }
    else
    {
        for ( int i = -1; i >= step; i--) {
            nextDir = ccp( -1, 0 );
            [_road addObject:[NSValue valueWithCGPoint:nextDir]];
        }
    }
    
    step = tmp.y / imageWidth;
    if ( step >= 0 )
    {
        for ( int i = 0; i <= step; i++ ) {
            nextDir = ccp( 0, 1 );
            [_road addObject:[NSValue valueWithCGPoint:nextDir]];
        }
    }
    else
    {
        for ( int i = 0; i >= step; i--) {
            nextDir = ccp( 0, -1 );
            [_road addObject:[NSValue valueWithCGPoint:nextDir]];
        }
    }
    
    NSLog(@"(%f, %f)", _head.position.x, _head.position.y);
    NSLog(@"(%f, %f)", fondPosition.x, fondPosition.y);
    NSLog(@"%@", _road);
    
    idxForRoad = 0;
    
    return _road;
}

- (void)move
{
    if ( idxForRoad < [_road count] )
    {
        CGPoint firstDir;
        [[_road objectAtIndex:idxForRoad] getValue:&firstDir];
        idxForRoad++;
        [super moveWithDir:firstDir];
    }
}

@end
