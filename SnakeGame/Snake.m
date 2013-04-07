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

- (id)initWithTheGame:(HelloWorldLayer *)game
{
    if ( self = [super init] )
    {
        _game = game;
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
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int imageWidth = _head.contentSize.width;
    
    [self addChild:_head];
    _head.position = ccp(imageWidth*4, winSize.height-_head.contentSize.height/2);
    
    // set the body on screen
    _body = [[NSMutableArray alloc] initWithCapacity:3];
    for ( int i = 3; i > 0; i-- )
    {
        CCSprite *tmpBody = [CCSprite spriteWithFile:@"body.png"];
        [self addChild:tmpBody];
        tmpBody.position = ccp(imageWidth*i, winSize.height-_head.contentSize.height/2);
        
        [_body addObject:tmpBody];
        
    }
    [_game addChild:self];
    
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

- (NSArray *)getBodyPosition
{
    return _body;
}

- (NSArray *)getAllPosition
{
    NSMutableArray *res = [NSMutableArray arrayWithObject:_head];
    for (CCSprite *item in _body)
    {
        [res addObject:item];
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

- (void)eatedFood
{
    CCSprite *tmpBody = [CCSprite spriteWithFile:@"body.png"];
    [self addChild:tmpBody];
    tmpBody.position = ((CCSprite*)[_body objectAtIndex:([_body count]-1)]).position;
    [_body addObject:tmpBody];
}

@end
