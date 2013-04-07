//
//  HelloWorldLayer.m
//  SnakeGame
//
//  Created by Jacob on 13-4-2.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "Snake.h"
#import "GameOverLayer.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
    {
		self.isTouchEnabled = YES;
        
		_snake = [[Snake alloc] initWithTheGame:self];
        [self schedule:@selector(update:) interval:0.1];
        [self schedule:@selector(eatFood) interval:1];
        
        _food = [CCSprite spriteWithFile:@"food.png"];
        [self addChild:_food];
        [self setFood];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_snake release];
    _snake = nil;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void) update:(ccTime)dt
{
    [_snake move];
    [self checkForCollision];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // judage the direction
    CGPoint offset = ccpSub(location, [_snake getHeadPosition]);
    if (offset.x == 0 && offset.y == 0) return;
    CGPoint dir;
    if ( fabs(offset.y) < fabs(offset.x) )
    {
        dir.y = 0;
        dir.x = offset.x > 0 ? 1 : -1;
    }
    else
    {
        dir.x = 0;
        dir.y = offset.y > 0 ? 1 : -1;
    }
    [_snake moveWithDir:dir];
    
}

- (void)setFood
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    int foodSize = _food.contentSize.width;
    int foodX = arc4random() % (int)(winSize.width-foodSize);
    int foodY = arc4random() % (int)(winSize.height-foodSize);
    _food.position = ccp( foodX, foodY );
}

- (void)eatFood
{
    float headImageSize = _snake.getHeadImageSize;
    float foodImageSize = _food.contentSize.width;
    float headConllisionRadius = headImageSize * 0.4f;
    float foodConllisionRadius = foodImageSize * 0.4f;
    
    float maxCollisionDistance = headConllisionRadius + foodConllisionRadius;
    
    float actualDistance = ccpDistance(_snake.getHeadPosition, _food.position);
    if ( actualDistance < maxCollisionDistance )
    {
        [_snake eatedFood];
        [self setFood];
    }
}

- (BOOL)outOfScreen
{
    CGPoint pos = [_snake getHeadPosition];
    int minX = [_snake getHeadImageSize]/2;
    int maxX = 480 - [_snake getHeadImageSize]/2;
    int minY = minX;
    int maxY = 320 - [_snake getHeadImageSize]/2;
    
    if ( (pos.x < minX || pos.x > maxX) || (pos.y < minY || pos.y > maxY) )
    {
        return YES;
    }
    return NO;
}

- (BOOL)suicide
{
    for (CCSprite *item in [_snake getBodyPosition])
    {
        if ( ccpDistance([_snake getHeadPosition], item.position) < [_snake getHeadImageSize]*0.4f )
        {
            return YES;
        }
    }
    return NO;
}

- (void)checkForCollision
{
    [self eatFood];
    if ( [self outOfScreen] || [self suicide] )
    {
        [self gameOver];
    }
}

- (void)gameOver
{
    [[CCDirector sharedDirector] replaceScene:[GameOverLayer sceneWithWon:NO]];
    [self reset];
}

- (void)reset
{
    if ( _snake != nil )
    {
        [_snake removeFromParentAndCleanup:YES];
        _snake = [[Snake alloc] initWithTheGame:self];
    }
}

@end
