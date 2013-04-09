//
//  AiSanke.m
//  SnakeGame
//
//  Created by Jacob on 13-4-7.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "AiSanke.h"


@implementation AiSanke
/*
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
    
    idxForRoad = 0;
    
    return _road;
}*/


- (void)moveNextWithAntherSnake:(NSArray*)snake withFood:(CGPoint)food
{
    NSArray *dirs = [NSArray arrayWithObjects:
                     [NSValue valueWithCGPoint:ccp(1, 0)],
                     [NSValue valueWithCGPoint:ccp(0, 1)],
                     [NSValue valueWithCGPoint:ccp(-1, 0)],
                     [NSValue valueWithCGPoint:ccp(0, -1)], nil];
    
    CGPoint realDir;
    CGPoint oldPos = _head.position;
    int imageWidth = _head.contentSize.width;
    
    float shortest = 10000000.f;
    CGPoint nextPos;
    //BOOL willMove = NO;
    int idx = -1;
    
    for ( int i = 0; i < [dirs count]; i++ )
    {
        [[dirs objectAtIndex:i] getValue:&realDir];
        
        //[self logPoint:_head.position];
        _head.position = ccp(_head.position.x+realDir.x*imageWidth, _head.position.y+realDir.y*imageWidth);
        //[self logPoint:_head.position];
        
        // if not dead, compute the shortest
        if ( ![self willDieWithAnotherSnake:snake] )
        {
            if ( ccpDistance(_head.position, food) < shortest )
            {
                //willMove = YES;
                idx = i;
                shortest = ccpDistance(_head.position, food);
                nextPos = _head.position;
            }
        }
        _head.position = oldPos;
    }
    
    if ( idx != -1 )
    {
        //_head.position = nextPos;
        [[dirs objectAtIndex:idx] getValue:&realDir];
    }
    else
    {
        [[dirs objectAtIndex:0] getValue:&realDir];
    }
    //[self moveWithDir:realDir];
    
    _dir = realDir;
}

- (void)logPoint:(CGPoint)p
{
    NSLog(@"x: %f, y: %f", p.x, p.y);
}

@end
