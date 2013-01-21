CZGPolygonLayer
===============

CZGPolygonLayer is a cocos2d CCNode subclass that lets you draw arbitrary collections of triangles.  In effect, it is an abstraction on an OpenGL triangle draw, but you get the benefits of being able to use it as a CCNode.

Overview
---


Installation
---

CZGPolygonLayer is wrapped up as a [cocoapod](cocoapods.org).  The easiest way to use it is to add it as a pod to your project.  CZGPolygonLayer depends on cocos2d being installed as a pod.  If you haven't done this, I recommend adding cocos2d as a pod to your existing project, then delete the cocos2d files that were added when you set up the project.


1.  Set up [cocoapods](http://cocoapods.org/) for your project. 
2.  Add CZGPolygonLayer as a pod


Example
===

GL_TRIANGLE_STRIP example
---

For a quick refresher, here's the order that GL_TRIANGLE_STRIP draws vertices:

	// Points in the polygon are drawn as GL_TRIANGLE_STRIP.
	// If you've got a number of points in a polygon, they're drawn in the
	// following order:
	//
	//       v1----v3----v5
	//        |\   |\    |\
	//        | \  | \   | \
	//        |  \ |  \  |  \
	//       v0---v2---v4----v6

	// See the HelloWorldLayer class in CZGPolygonLayerExample project for some sample usage.


```objective-c

	// We're going to draw an n-sided radially symmetrical polygon.
	self.polygon = [CZGPolygonLayer nodeWithPoints: 100];
	_polygon.position = center;
	// polygon point positions are updated in update: method
	// We move the points in and out from the center to create an amoeba-like effect
	[self update: 0];
 	[self addChild: _polygon];

	...

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
```

GL_TRIANGLE_FAN example
---



```objective-c
	// For a quick refresher, here's the order that GL_TRIANGLE_STRIP draws vertices:

	// Points in the polygon are drawn as GL_TRIANGLE_STRIP.
	// If you've got a number of points in a polygon, they're drawn in the
	// following order:
	//
	//       v2----v3----v4
	//        |\   |    /|
	//        | \  |  /  |
	//        |  \ |/    |
	//       v1---v0-----v5
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
```

GL_TRIANGLES example
---

```objective-c
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
```
