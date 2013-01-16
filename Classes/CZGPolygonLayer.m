//
//  CZGPolygonNode.m
//  word-game-3
//
//  Created by Garrett Christopher on 5/12/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

#import "CZGPolygonLayer.h"
#import "cocos2d.h"

@interface CZGPolygonLayer() {
   ccBlendFunc _blendFunc;
   ccVertex2F *_points;
   ccColor4F *_fillColors;
}

@end

@implementation CZGPolygonLayer

@synthesize numberOfPoints = _numberOfPoints;

+ (CZGPolygonLayer *) nodeWithPoints:(int)numPoints {
   return [[CZGPolygonLayer alloc] initWithPoints: numPoints];
}

// Initialise the object. Allocate the array of points and set the default values.
// by default this will draw a closed white polygon with a red border
-(id) initWithPoints:(int)numPoints {
	if( (self=[super init]) ) {
      _numberOfPoints = numPoints;
      _points = calloc(numPoints, sizeof(ccVertex2F));
      _fillColors = calloc(numPoints, sizeof(ccColor4F));
      
      for (int i=0; i< numPoints; i++) {
          _fillColors[i] = ccc4f(0.0, 1.0, 0.0, 1.0);
      }
      
      self.shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionColor];
		_blendFunc = (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA };

	}
	return self;
}

- (void) setPoint: (CGPoint) pt atIndex: (int) index {
   ccVertex2F vPoint;
   vPoint.x = pt.x;
   vPoint.y = pt.y;
   _points[index] = vPoint;
}

- (void) setFillColor: (ccColor4F) color atIndex: (int) index {
   _fillColors[index] = color;
}

// Override the node draw method. Call the ccDrawPoly method
// to perform the OpenGL draw operation
-(void) draw {
	[super draw];
   [self ccDrawPoly];
}

// Draw the polygon using OpenGL
-(void) ccDrawPoly  {
   CC_NODE_DRAW_SETUP();
   
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_Color );
   
	//
	// Attributes
	//
	glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, _points);
	glVertexAttribPointer(kCCVertexAttrib_Color, 4, GL_FLOAT, GL_FALSE, 0, _fillColors);
   
	ccGLBlendFunc( _blendFunc.src, _blendFunc.dst );
   
	glDrawArrays(GL_TRIANGLE_STRIP, 0, _numberOfPoints);
   
   /*
   glLineWidth(2.0);
   glDrawArrays(GL_LINE_LOOP, 0, (GLsizei) numberOfPoints);
	*/
	CC_INCREMENT_GL_DRAWS(1);
}

-(void) dealloc {
   free(_points);
   free(_fillColors);
}

@end

