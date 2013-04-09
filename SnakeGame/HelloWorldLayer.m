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
#import "AiSanke.h"

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
        
		_snake = [[Snake alloc] initWithTheGame:self withImageName:@"body.png" withHeadPosition:ccp(128,288)];
        _aiSnake = [[AiSanke alloc] initWithTheGame:self withImageName:@"ai_body.png" withHeadPosition:ccp(128,32)];
        [self schedule:@selector(updateQuick) interval:0.2];
        [self schedule:@selector(updateSlow) interval:1];
        
        _food = [CCSprite spriteWithFile:@"food.png"];
        [self addChild:_food];
        [self setFood];
        
        [self addSorceLabels];
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

- (BOOL)isEmpty:(CGPoint)pos
{
    CGPoint cur;
    for (NSValue *item in [_snake getAllPositions])
    {
        [item getValue:&cur];
        if ( ccpDistance(cur, pos) < _food.contentSize.width/2 )
        {
            return NO;
        }
    }
    
    for ( NSValue *item in [_aiSnake getAllPositions] )
    {
        [item getValue:&cur];
        if ( ccpDistance(cur, pos) == _food.contentSize.width/2 )
        {
            return NO;
        }
    }
    return YES;
}

- (void)setFood
{
    CGPoint newPos;
    do {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        int foodSize = _food.contentSize.width;
        int x = arc4random() % (int)(winSize.width-foodSize*2);
        int y = arc4random() % (int)(winSize.height-foodSize*2);
        int foodX = x/foodSize*foodSize+foodSize*1.5;
        int foodY = y/foodSize*foodSize+foodSize*1.5;
        newPos = ccp( foodX, foodY );
    } while ( ![self isEmpty:newPos] );
    
    _food.position = newPos;
}

- (void)checkForCollision
{
    if ( [_snake eatFoodWithFoodPosition:_food] || [_aiSnake eatFoodWithFoodPosition:_food] )
    {
        [self setFood];
        [self changeScrceLabels];
    }
    
    if ( [_snake willDieWithAnotherSnake:[_aiSnake getAllPositions]] )
    {
        [self gameOver:NO];
    }
    
    if ( [_aiSnake willDieWithAnotherSnake:[_snake getAllPositions]] )
    {
        [self gameOver:YES];
    }
    
    if ( _snake.sorce >= 10 )
    {
        [self gameOver:YES];
    }
    
    if ( _aiSnake.sorce >= 10 )
    {
        [self gameOver:NO];
    }
}

- (void)gameOver:(BOOL)won
{
    [[CCDirector sharedDirector] replaceScene:[GameOverLayer sceneWithWon:won]];
    [self reset];
}

- (void)reset
{
    if ( _snake != nil )
    {
        [_snake removeFromParentAndCleanup:YES];
    }
}

# pragma mark - update methods

- (void) updateQuick
{
    [_snake move];
    [_aiSnake move];
    
    [self checkForCollision];
}

- (void) updateSlow
{
    [_aiSnake moveNextWithAntherSnake:[_snake getAllPositions] withFood:_food.position];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    /*
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
     [_snake moveWithDir:dir];*/
    
    [_snake moveWithTouchPoint:location];
}


#pragma mark - some methods for sorce labels

- (void)addSorceLabels
{
    _snakeSorceLabel = [CCLabelTTF labelWithString:@"Earth Snake: 0" fontName:@"Arial" fontSize:16];
    _aiSnakeSorceLabel = [CCLabelTTF labelWithString:@"Mars Snake: 0" fontName:@"Arial" fontSize:16];
    [self addChild:_snakeSorceLabel];
    [self addChild:_aiSnakeSorceLabel];
    _snakeSorceLabel.position = ccp(20+_snakeSorceLabel.contentSize.width/2,300);
    _aiSnakeSorceLabel.position = ccp(460-_aiSnakeSorceLabel.contentSize.width/2,300);
}

- (void)changeScrceLabels
{
    [_snakeSorceLabel setString:[NSString stringWithFormat:@"Earth Snake: %d", _snake.sorce]];
    [_aiSnakeSorceLabel setString:[NSString stringWithFormat:@"Mars Snake: %d", _aiSnake.sorce]];
}

@end
