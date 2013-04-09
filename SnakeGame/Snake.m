//
//  Snake.m
//  SnakeGame
//
//  Created by Jacob on 13-4-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Snake.h"
#import "HelloWorldLayer.h"

@implementation Snake

@synthesize sorce;

- (id)initWithTheGame:(HelloWorldLayer *)game withImageName:(NSString *)filename withHeadPosition:(CGPoint)pos
{
    if ( self = [super init] )
    {
        self.sorce = 0;
        
        _game = game;
        _bodyImageName = filename;
        _initHeadPos = pos;
        
        [self addSnake];
    }
    return self;
}

- (void)dealloc
{
    [_body release];
    _body = nil;
    [super dealloc];
}

- (void) addSnake
{
    _dir = ccp(1,0);
    _head = [CCSprite spriteWithFile:@"head.png"];
    int imageWidth = _head.contentSize.width;
    
    [self addChild:_head];
    _head.position = _initHeadPos;
    
    // set the body on screen
    _body = [[NSMutableArray alloc] initWithCapacity:3];
    for ( int i = 3; i > 0; i-- )
    {
        CCSprite *tmpBody = [CCSprite spriteWithFile:_bodyImageName];
        [self addChild:tmpBody];
        tmpBody.position = ccp(imageWidth*i, _head.position.y);
        
        [_body addObject:tmpBody];
        
    }
    [_game addChild:self];
    
}

- (void)moveWithTouchPoint:(CGPoint)touchPoint
{
    CGPoint offset = ccpSub(touchPoint, _head.position);
    
    if ( _dir.x == 0 )
    {
        if ( offset.x < 0 )
        {
            _dir = ccp(-1,0);
        }
        else if ( offset.x > 0 )
        {
            _dir = ccp(1,0);
        }
    }
    else if ( _dir.y == 0 )
    {
        if ( offset.y < 0 )
        {
            _dir = ccp(0,-1);
        }
        else if ( offset.y > 0 )
        {
            _dir = ccp(0,1);
        }
    }
    [self move];
}

-(void)moveWithDir:(CGPoint)dir
{
    _dir = ccp(dir.x, dir.y);
    
    int range = _head.contentSize.width;
    int duration = 1;
    CGPoint fontPos = _head.position;
    
    // move the hand
    CGPoint nextPos = ccp(_head.position.x+(dir.x)*range, _head.position.y+(dir.y)*range);
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:duration position:nextPos];
    CCCallBlock *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {}];
    [_head runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    // move the body
    for ( CCSprite *sprite in _body )
    {
        nextPos = fontPos;
        fontPos = sprite.position;
        CCMoveTo *actionMove = [CCMoveTo actionWithDuration:duration position:nextPos];
        CCCallBlock *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {}];
        [sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    }
}

- (CGPoint)getHeadPosition
{
    return _head.position;
}

- (CGPoint)getDir
{
    return _dir;
}

- (int)getHeadImageSize
{
    return _head.contentSize.width;
}

- (NSArray *)getAllPositions
{
    NSMutableArray *res = [NSMutableArray array];
    NSValue *pos = [NSValue valueWithCGPoint:_head.position];
    [res addObject:pos];
    for (CCSprite *item in _body)
    {
        pos = [NSValue valueWithCGPoint:item.position];
        [res addObject:pos];
    }
    return res;
}

-(void)move
{
    int range = _head.contentSize.width;
    int duration = 1;
    CGPoint fontPos = _head.position;
    
    // move the hand
    CGPoint nextPos = ccp(_head.position.x+_dir.x*range, _head.position.y+_dir.y*range);
    CCMoveTo *actionMove = [CCMoveTo actionWithDuration:duration position:nextPos];
    CCCallBlock *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {}];
    [_head runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    // move the body
    for ( CCSprite *sprite in _body )
    {
        nextPos = fontPos;
        fontPos = sprite.position;
        CCMoveTo *actionMove = [CCMoveTo actionWithDuration:duration position:nextPos];
        CCCallBlock *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node) {}];
        [sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    }
}

- (BOOL)eatFoodWithFoodPosition:(CCSprite *)food
{
    float headImageSize = _head.contentSize.width;
    float foodImageSize = food.contentSize.width;
    float headConllisionRadius = headImageSize * 0.4f;
    float foodConllisionRadius = foodImageSize * 0.4f;
    
    float maxCollisionDistance = headConllisionRadius + foodConllisionRadius;
    
    float actualDistance = ccpDistance(_head.position, food.position);
    if ( actualDistance < maxCollisionDistance )
    {
        [self eatedFood];
        return YES;
    }
    return NO;
}

- (void)eatedFood
{
    self.sorce++;
    
    CCSprite *tmpBody = [CCSprite spriteWithFile:_bodyImageName];
    [self addChild:tmpBody];
    tmpBody.position = ((CCSprite*)[_body objectAtIndex:([_body count]-1)]).position;
    [_body addObject:tmpBody];
}

- (BOOL)outOfScreen
{
    CGPoint pos = _head.position;
    int minX = _head.contentSize.width/2;
    int maxX = 480 - _head.contentSize.width/2;
    int minY = minX;
    int maxY = 320 - _head.contentSize.width/2;
    
    if ( (pos.x < minX || pos.x > maxX) || (pos.y < minY || pos.y > maxY) )
    {
        return YES;
    }
    return NO;
}

- (BOOL)suicide
{
    // ignore the collision between head and 1st, 2nd bodys
    for ( int i = 0; i < [_body count]; i++ )
    {
        CCSprite *item = [_body objectAtIndex:i];
        if ( ccpDistance(_head.position, item.position) < _head.contentSize.width * 0.5 )
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)beKill:(NSArray *)snake
{
    if ( snake != nil )
    {
        CGPoint pos;
        for ( NSValue *item in snake )
        {
            [item getValue:&pos];
            if ( ccpDistance(_head.position, pos) < _head.contentSize.width )
            {
                return YES;
            }
        }
    }
    return NO;
}


- (BOOL)willDieWithAnotherSnake:(NSArray *)snake
{
    return ( [self outOfScreen] || [self suicide] || [self beKill:snake] );
}

@end
