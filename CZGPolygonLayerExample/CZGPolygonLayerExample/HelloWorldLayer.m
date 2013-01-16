//
//  HelloWorldLayer.m
//  CZGPolygonLayerExample
//
//  Created by Christopher Garrett on 1/16/13.
//  Copyright ZWorkbench 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "CZGPolygonLayer.h"

#pragma mark - HelloWorldLayer

@interface HelloWorldLayer() {
    ccTime _time;
}

@property (nonatomic, assign) CZGPolygonLayer *polygon;

@end

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize polygon = _polygon;

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
	if( (self=[super init]) ) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint center = ccp(size.width/2, size.height/2);

        // We're going to draw an n-sided radially symmetrical polygon.
		self.polygon = [CZGPolygonLayer nodeWithPoints: 100];
        _polygon.position = center;
        // polygon point positions are updated in update: method
        [self update: 0];
        
        [self addChild: _polygon];
        
        
        // create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

	
		// position the label on the center of the screen
		label.position =  center;
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achievementViewController = [[GKAchievementViewController alloc] init];
			achievementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achievementViewController animated:YES];
			
			[achievementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        [self scheduleUpdate];

	}
	return self;
}

- (void) update: (ccTime) dt {
    _time += dt;
    int sides = _polygon.numberOfPoints;
    float relativeMovement = 0.1;
    for (int i=0; i< sides; i++) {
        int vertexIndex = i%2 ?  (i+1)/2 : (sides-(i/2))%sides;
        // we're going to move each individual vertex in and out, hovering around a radius of 200.0
        float radius = (relativeMovement*sinf(_time - (M_PI*2.0*i/sides)) + 1.0 - relativeMovement) * 200.0;
        [_polygon setPoint: ccp(radius*cosf(M_PI*2.0*vertexIndex/sides),
                                radius*sinf(M_PI*2.0*vertexIndex/sides))
                   atIndex: i];
        [_polygon setFillColor: ccc4f(0.0, 1.0, 0.0, 1.0) atIndex: i];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    self.polygon = nil;
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
