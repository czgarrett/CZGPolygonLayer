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
@property (nonatomic, assign) CZGPolygonLayer *star;
@property (nonatomic, assign) CZGPolygonLayer *coloredStar;

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
        
        // Draw an n-pointed star using GL_TRIANGLE_FAN
        int points = 5;
        float radius = 100;
		self.star = [CZGPolygonLayer nodeWithPoints: points*2+2];
        float angleIncrement = M_PI/points;
        for (int i=0; i< points*2+1; i+=2) {
            float innerAngle = i*angleIncrement;
            float outerAngle = (1 + i)*angleIncrement;
            // inner point
            [self.star setPoint: ccp(0.5*radius*cosf(innerAngle), 0.5*radius*sinf(innerAngle)) atIndex: i+1];
            [self.star setFillColor: ccc4f(1.0, 0.0, 0.0, 1.0) atIndex: i+1];
            // outer point
            if (i+2 < points*2+2) {
                [self.star setPoint: ccp(radius*cosf(outerAngle), radius*sinf(outerAngle)) atIndex: i+2];
                [self.star setFillColor: ccc4f(1.0, 0.0, 0.0, 1.0) atIndex: i+2];
            }
        }
        [self.star setFillColor: ccc4f(1.0, 1.0, 0.0, 1.0) atIndex: 0];
        self.star.drawMode = GL_TRIANGLE_FAN;
        self.star.position = ccp(center.x - radius*2,
                                 center.y - radius*2);
        [self addChild: self.star];
        
        // Draw an n-pointed star using GL_TRIANGLES
		self.coloredStar = [CZGPolygonLayer nodeWithPoints: points*6];
        for (int i=0; i< points; i++) {
            float currentAngle = 2*i*angleIncrement;
            float middleAngle = (1 + 2*i)*angleIncrement;
            float nextAngle = (2 + 2*i)*angleIncrement;
            CGPoint center = ccp(0,0);
            CGPoint current = ccp(radius*cosf(currentAngle), radius*sinf(currentAngle));
            CGPoint middle = ccp(0.5*radius*cosf(middleAngle), 0.5*radius*sinf(middleAngle));
            CGPoint next = ccp(radius*cosf(nextAngle), radius*sinf(nextAngle));
            
            // First triangle
            [self.coloredStar setPoint: center atIndex: i*6];
            [self.coloredStar setFillColor: ccc4f(1.0, 1.0, 0.0, 1.0) atIndex: i*6];
            [self.coloredStar setPoint: middle atIndex: i*6+1];
            [self.coloredStar setFillColor: ccc4f(1.0, 1.0, 0.0, 1.0) atIndex: i*6+1];
            [self.coloredStar setPoint: current atIndex: i*6+2];
            [self.coloredStar setFillColor: ccc4f(0.8, 0.8, 0.0, 1.0) atIndex: i*6+2];
            
            // Second triangle
            [self.coloredStar setPoint: center atIndex: i*6+3];
            [self.coloredStar setFillColor: ccc4f(0.8, 0.8, 0.0, 1.0) atIndex: i*6+3];
            [self.coloredStar setPoint: next atIndex: i*6+4];
            [self.coloredStar setFillColor: ccc4f(0.7, 0.7, 0.0, 1.0) atIndex: i*6+4];
            [self.coloredStar setPoint: middle atIndex: i*6+5];
            [self.coloredStar setFillColor: ccc4f(0.6, 0.6, 0.0, 1.0) atIndex: i*6+5];

        }
        self.coloredStar.drawMode = GL_TRIANGLES;
        self.coloredStar.position = ccp(center.x + radius*2,
                                 center.y + radius*2);
        [self addChild: self.coloredStar];

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
        float radius = (relativeMovement*sinf(_time - (M_PI*2.0*i/sides)) + 1.0 - relativeMovement) * 100.0;
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
