CZGPolygonLayer
===============

CZGPolygonLayer is a cocos2d CCNode subclass that lets you draw arbitrary triangle strips.  In effect, it is an abstraction on an OpenGL triangle strip draw, but you get the benefits of being able to use it as a CCNode.

For a quick refresher, here's the order that GL_TRIANGLE_STRIP draws vertices:

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


Example:

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
