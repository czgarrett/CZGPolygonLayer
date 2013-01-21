//
//  CZGPolygonNode.h
//
//  Created by Garrett Christopher on 5/12/12.
//  Copyright (c) 2012 ZWorkbench, Inc. All rights reserved.
//

// Points in the polygon are drawn as GL_TRIANGLE_STRIP.
// To refresh your memory, if you've got a number of points in a polygon, they're drawn in the
// following order:
//
//       v1----v3----v5
//        |\   |\    |\
//        | \  | \   | \
//        |  \ |  \  |  \
//       v0---v2---v4----v6

// See the HelloWorldLayer class in CZGPolygonLayerExample project for some sample usage.

#import "cocos2d.h"

@interface CZGPolygonLayer : CCNode

// Store the number of points in the polygon
@property (readonly) int numberOfPoints;

// GL_TRIANGLE_STRIP, GL_TRIANGLE_FAN, or GL_TRIANGLES.  Default is GL_TRIANGLE_STRIP
@property (nonatomic, assign) GLenum drawMode;

+ (CZGPolygonLayer *) nodeWithPoints: (int) numPoints;
- (id) initWithPoints: (int) numPoints;

- (void) setPoint: (CGPoint) pt atIndex: (int) index;
- (void) setFillColor: (ccColor4F) color atIndex: (int) index;

@end
